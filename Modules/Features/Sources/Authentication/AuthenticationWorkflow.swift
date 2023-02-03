// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import Ergo
import CovenAPI

import enum Assets.Strings
import struct Coven.Credentials
import struct Coven.User
import struct Coven.Account
import struct Coven.PhoneNumber
import protocol CovenService.AuthenticationSpec

public extension Authentication {
	struct Workflow<Service: AuthenticationSpec> where
		Service.VerificationResult == Credentials.Verification.Result,
		Service.AuthenticationResult == Account.Authentication.Result {
		private let initialUsername: User.Username
		private let initialPhoneNumber: PhoneNumber
		private let service: Service

		public init(
			service: Service,
			initialUsername: User.Username,
			initialPhoneNumber: PhoneNumber
		) {
			self.service = service
			self.initialUsername = initialUsername
			self.initialPhoneNumber = initialPhoneNumber
		}
	}
}

// MARK: -
extension Authentication.Workflow: Workflow {
	public typealias Rendering = AnyScreen
	public typealias Output = Account.Identified.ID

	public struct State {
		var username: User.Username
		var phoneNumber: PhoneNumber
		var invalidPhoneNumbers: [User.Username: [PhoneNumber]] = [:]
		var invalidUsernames: [PhoneNumber: [User.Username]] = [:]
		var verificationState: Credentials.Verification.State = .idle
		var authenticationState: Account.Authentication.State = .idle
	}

	public func makeInitialState() -> State {
		.init(
			username: initialUsername,
			phoneNumber: initialPhoneNumber
		)
	}

	public func render(state: State, context: RenderContext<Self>) -> Rendering {
		context.run(
			state
				.verificationWorker(using: service)?
				.mapOutput(Action.finishVerification)
		)

		context.run(
			state
				.authenticationWorker(authenticating: state.credentials, using: service)?
				.mapOutput(Action.finishAuthentication)
		)

		return screen(
			state: state,
			sink: context.makeSink(of: Action.self)
		).asAnyScreen()
	}
}

// MARK: -
extension Authentication.Workflow {
	enum Action {
		case updateUsername(User.Username)
		case updatePhoneNumber(PhoneNumber)
		case verify
		case finishVerification(Credentials.Verification.Result)
		case authenticate
		case finishAuthentication(Account.Authentication.Result)
		case dismissAlert
	}
}

// MARK: -
private extension Authentication.Workflow {
	func screen(state: State, sink: Sink<Action>) -> Alert.Screen<Authentication.Screen> {
		.init(
			baseScreen: .init(
				username: state.username,
				phoneNumber: state.phoneNumber,
				usernameTextEdited: { sink.send(.updateUsername(.init(text: $0))) },
				phoneNumberTextEdited: { sink.send(.updatePhoneNumber(.init(text: $0))) },
				submitTapped: { sink.send(.verify) },
				isVerifyingCredentials: state.isVerifyingCredentials,
				hasInvalidUsername: state.hasInvalidUsername,
				hasInvalidPhoneNumber: state.hasInvalidPhoneNumber
			),
			alert: state.alert {
				sink.send(.dismissAlert)
			}
		)
	}
}

// MARK: -
extension Authentication.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Authentication.Workflow<Service>

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case let .updateUsername(username):
			state.username = username
		case let .updatePhoneNumber(phoneNumber):
			state.phoneNumber = phoneNumber
		case .verify:
			state.verificationState = .requesting
		case let .finishVerification(.success(verification)):
			state.verificationState = .retrieved(verification)
			switch verification {
			case .match, .creation:
				state.authenticationState = .requesting
			case let .mismatch(mismatch):
				state.handle(mismatch)
			}
		case let .finishVerification(.failure(error)):
			state.verificationState = .failed(error)
		case .authenticate:
			state.authenticationState = .requesting
		case let .finishAuthentication(.success(accountID)):
			return accountID
		case let .finishAuthentication(.failure(error)):
			state.authenticationState = .failed(error)
		case .dismissAlert:
			state.verificationState = .idle
		}
		return nil
	}
}

// MARK: -
private extension Authentication.Workflow.State {
	var credentials: Credentials {
		.init(
			account: .init(
				phoneNumber: phoneNumber
			),
			user: .init(
				username: username
			)
		)
	}

	var isVerifyingCredentials: Bool {
		verificationState.isRequesting
	}

	var hasInvalidUsername: Bool {
		invalidUsernames[phoneNumber]?.contains(username) ?? false
	}

	var hasInvalidPhoneNumber: Bool {
		invalidPhoneNumbers[username]?.contains(phoneNumber) ?? false
	}

	func verificationWorker(using service: Service) -> RequestWorker<Credentials.Verification.Result>? {
		verificationState.mapRequesting(
			.init {
				await service.verify(
					username: username,
					phoneNumber: phoneNumber
				)
			}
		)
	}

	func authenticationWorker(authenticating credentials: Credentials, using service: Service) -> RequestWorker<Account.Authentication.Result>? {
		authenticationState.mapRequesting(
			.init {
				//////////// authenticationState.requestWorker {
				await service.authenticate(credentials.account, for: credentials.user)
			}
		)
	}

	func alert(dismissHandler: @escaping () -> Void) -> Alert? {
		let strings = Strings.Alert.self
		return verificationState.mapError { error in
			.init(
				title: strings.Error.network,
				message: error.message,
				actions: [
					.init(
						title: strings.dismiss,
						handler: dismissHandler
					)
				]
			)
		}
	}

	mutating func handle(_ mismatch: Credentials.Verification.Mismatch) {
		switch mismatch {
		case .username:
			invalidUsernames[phoneNumber, default: []].append(username)
		case .phoneNumber:
			invalidPhoneNumbers[username, default: []].append(phoneNumber)
		}
	}
}
