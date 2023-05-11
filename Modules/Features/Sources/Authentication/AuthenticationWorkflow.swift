// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowReactiveSwift
import WorkflowContainers
import ReactiveSwift
import Ergo
import CovenAPI

import enum Assets.Strings
import enum Catenary.Request
import struct Coven.Credentials
import struct Coven.User
import struct Coven.Account
import struct Coven.PhoneNumber
import protocol CovenService.LoginSpec
import protocol CovenService.CredentialsSpec

public extension Authentication {
	struct Workflow<
		LoginService: LoginSpec,
		CredentialsService: CredentialsSpec
	> where
		LoginService.LoginResult == Account.Login.Result,
		CredentialsService.VerificationResult == Credentials.Verification.Result {
		private let loginService: LoginService
		private let credentialsService: CredentialsService
		private let initialCredentials: Credentials

		public init(
			loginService: LoginService,
			credentialsService: CredentialsService,
			initialCredentials: Credentials
		) {
			self.loginService = loginService
			self.credentialsService = credentialsService
			self.initialCredentials = initialCredentials
		}
	}
}

// MARK: -
extension Authentication.Workflow: Workflow {
	public typealias Rendering = AnyScreen
	public typealias Output = Account.Identified.ID

	public struct State {
		var credentials: Credentials
		var verificationWorker: VerificationWorker
		var invalidPhoneNumbers: [User.Username: [PhoneNumber]] = [:]
		var invalidUsernames: [PhoneNumber: [User.Username]] = [:]
	}

	public func makeInitialState() -> State {
		.init(
			credentials: initialCredentials,
			verificationWorker: .init(
				work: credentialsService.verify,
				succeed: Action.finishVerification,
				fail: Action.handleError
			)
		)
	}

	public func render(state: State, context: RenderContext<Self>) -> Rendering {
		context.render { (sink: Sink<Action>) in
			Alert.Screen<Authentication.Screen>(
				baseScreen: .init(
					username: state.username,
					phoneNumber: state.phoneNumber,
					usernameTextEdited: { sink.send(.updateUsername(.init(text: $0))) },
					phoneNumberTextEdited: { sink.send(.updatePhoneNumber(.init(text: $0))) },
					submitTapped: { sink.send(.verifyCredentials) },
					isVerifyingCredentials: state.isVerifyingCredentials,
					hasInvalidUsername: state.hasInvalidUsername,
					hasInvalidPhoneNumber: state.hasInvalidPhoneNumber
				),
				alert: state.alert {
					sink.send(.dismissAlert)
				}
			)
		} workers: {
			state.verificationWorker.asAnyWorkflow()
		}
	}
}

// MARK: -
extension Authentication.Workflow {
	typealias Login = Account.Login
	typealias LoginWorker = ActionWorker<Action, Credentials, Login, Login.Result.Error>
	typealias Verification = Credentials.Verification
	typealias VerificationWorker = ActionWorker<Action, Credentials, Verification, Verification.Result.Error>

	enum Action {
		case updateUsername(User.Username)
		case updatePhoneNumber(PhoneNumber)
		case verifyCredentials
		case finishVerification(Credentials.Verification)
		case handleError(Request.Error<API.Error>)
		case dismissAlert
	}
}

// MARK: -
extension Authentication.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Authentication.Workflow<LoginService, CredentialsService>

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case let .updateUsername(username):
			state.credentials.username = username
		case let .updatePhoneNumber(phoneNumber):
			state.credentials.phoneNumber = phoneNumber
		case .verifyCredentials:
			state.verificationWorker.work(with: state.credentials)
		case let .finishVerification(verification):
			switch verification {
			case .match, .creation:
				break
			case let .mismatch(mismatch):
				state.handle(mismatch)
			}
		case let .handleError(error):
			break
		case .dismissAlert:
			break
		}
		return nil
	}
}

// MARK: -
private extension Authentication.Workflow.State {
	var username: User.Username {
		credentials.username
	}

	var phoneNumber: PhoneNumber {
		credentials.phoneNumber
	}

	var isVerifyingCredentials: Bool {
		verificationWorker.isExecuting
	}

	var hasInvalidUsername: Bool {
		invalidUsernames[credentials.phoneNumber]?.contains(username) ?? false
	}

	var hasInvalidPhoneNumber: Bool {
		invalidPhoneNumbers[username]?.contains(phoneNumber) ?? false
	}

	func alert(dismissHandler: @escaping () -> Void) -> Alert? {
//		let strings = Strings.Alert.self
//		return verificationState.mapError { error in
//			.init(
//				title: strings.Error.network,
//				message: error.message,
//				actions: [
//					.init(
//						title: strings.dismiss,
//						handler: dismissHandler
//					)
//				]
//			)
//		}
		nil
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
