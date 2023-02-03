// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import Ergo
import CovenAPI
import TextbeltAPI

import struct Coven.Credentials
import struct Coven.User
import struct Coven.PhoneNumber
import struct Coven.Account
import struct Textbelt.OTP
import protocol CovenService.AuthenticationSpec
import protocol CovenService.CredentialsSpec
import protocol TextbeltService.OTPSpec

public extension Authentication {
	struct Workflow<
		AuthenticationService: AuthenticationSpec,
		CredentialsService: CredentialsSpec,
		OTPService: OTPSpec
	> where
		AuthenticationService.Result == Account.Authentication.Result,
		CredentialsService.VerificationResult == Coven.Credentials.Verification.Result,
		OTPService.DeliveryResult == OTP.Delivery.Result,
		OTPService.VerificationResult == OTP.Verification.Result {
		private let initialUsername: Coven.User.Username
		private let initialPhoneNumber: Coven.PhoneNumber
		private let authenticationService: AuthenticationService
		private let credentialsService: CredentialsService
		private let otpService: OTPService

		public init(
			initialUsername: Coven.User.Username = .empty,
			initialPhoneNumber: Coven.PhoneNumber = .empty,
			authenticationService: AuthenticationService,
			credentialsService: CredentialsService,
			otpService: OTPService
		) {
			self.initialUsername = initialUsername
			self.initialPhoneNumber = initialPhoneNumber
			self.authenticationService = authenticationService
			self.credentialsService = credentialsService
			self.otpService = otpService
		}
	}
}

// MARK: -
extension Authentication.Workflow: Workflow {
	public typealias Rendering = AnyScreen
	public typealias Output = Account.Identified.ID

	public struct State {
		var input: Input
		var authenticationState: Authentication.State = .idle
	}

	public func makeInitialState() -> State {
		.init(input: .credentials())
	}

	public func render(state: State, context: RenderContext<Self>) -> Rendering {
		let sink = context.makeSink(of: Action.self)
		return Alert.Screen(
			baseScreen: BackStack.Screen(
				items: items(with: state, in: context)
			), alert: state.alert {
				sink.send(.authenticate)
			}
		).asAnyScreen()
	}
}

// MARK: -
private extension Authentication.Workflow {
	enum Action {
		case confirm(Credentials)
		case authenticate
		case finishAuthentication(Account.Authentication.Result)
		case cancel(switchPhoneNumber: Bool)
	}

	func items(with state: State, in context: RenderContext<Self>) -> [BackStack.Item] {
		switch state.input {
		case let .credentials(needsPhoneNumberReinput):
			return [credentialsItem(with: state, in: context, needingPhoneNumberReinput: needsPhoneNumberReinput)]
		case let .confirmationCode(credentials):
			return [
				credentialsItem(with: state, in: context, needingPhoneNumberReinput: false),
				confirmationItem(with: state, in: context, for: credentials)
			]
		}
	}

	func credentialsItem(with state: State, in context: RenderContext<Self>, needingPhoneNumberReinput: Bool) -> BackStack.Item {
		let workflow = Authentication.Credentials.Workflow(
			initialUsername: initialUsername,
			initialPhoneNumber: initialPhoneNumber,
			needsPhoneNumberReinput: needingPhoneNumberReinput,
			service: credentialsService
		)

		return workflow
			.mapOutput(Action.confirm)
			.rendered(in: context)
	}

	func confirmationItem(with state: State, in context: RenderContext<Self>, for credentials: Credentials) -> BackStack.Item {
		let workflow = Authentication.Confirmation.Workflow(
			credentials: credentials,
			otpService: otpService
		)

		context.run(
			state
				.worker(authenticating: credentials.account, for: credentials.user, using: authenticationService)?
				.mapOutput(Action.finishAuthentication)
		)

		return workflow
			.mapOutput(confirmationAction)
			.rendered(in: context)
	}

	func confirmationAction(for output: Authentication.Confirmation.Workflow<OTPService>.Output) -> Action {
		switch output {
		case .confirmation:
			return .authenticate
		case let .cancellation(switchPhoneNumber):
			return .cancel(switchPhoneNumber: switchPhoneNumber)
		}
	}
}

// MARK: -
extension Authentication.Workflow.State {
	typealias Authentication = Account.Authentication

	enum Input {
		case credentials(needsPhoneNumberReinput: Bool = false)
		case confirmationCode(Credentials)
	}
}

// MARK: -
private extension Authentication.Workflow.State {
	func worker(authenticating account: Account, for user: User, using service: AuthenticationService) -> RequestWorker<Authentication.Result>? {
		authenticationState.mapRequesting(
			.init {
				await service.authenticate(account, for: user)
			}
		)
	}

	func alert(tryAgainHandler: @escaping () -> Void) -> Alert? {
		authenticationState.mapError { error in
			.init(
				title: "Authentication Error",
				message: "We were unable to authenticate your account. Please try again.",
				actions: [
					.init(
						title: "Try Again",
						handler: tryAgainHandler
					)
				]
			)
		}
	}
}

// MARK: -
extension Authentication.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Authentication.Workflow<AuthenticationService, CredentialsService, OTPService>

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case let .confirm(credentials):
			state.input = .confirmationCode(credentials)
		case .authenticate:
			state.authenticationState = .requesting
		case let .finishAuthentication(.success(accountID)):
			return accountID
		case let .finishAuthentication(.failure(error)):
			state.authenticationState = .failed(error)
		case let .cancel(switchPhoneNumber):
			state.input = .credentials(needsPhoneNumberReinput: switchPhoneNumber)
		}
		return nil
	}
}
