// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import Ergo
import CovenAPI

import enum Assets.Strings
import struct Coven.User
import struct Coven.Account
import struct Coven.Credentials
import protocol CovenService.LoginSpec
import protocol CovenService.CredentialsSpec

public extension Authentication {
	struct Workflow<
		LoginService: LoginSpec,
		CredentialsService: CredentialsSpec
	> where
		LoginService.LoginResult == Login.Result,
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
	public typealias Output = Account.Identified.ID

	public struct State {
		fileprivate var credentials: Credentials
		fileprivate var invalidPasswords: [User.Username: [String]] = [:]
		fileprivate var invalidUsernames: [String: [User.Username]] = [:]

		fileprivate let loginWorker: LoginWorker
		fileprivate let verificationWorker: VerificationWorker
	}

	public func makeInitialState() -> State {
		.init(
			credentials: initialCredentials,
			loginWorker: .ready(to: loginService.logIn),
			verificationWorker: .ready(to: credentialsService.verify)
		)
	}

	public func render(state: State, context: RenderContext<Self>) -> AnyScreen {
		context.render { (sink: Sink<Action>) in
			Alert.Screen<Authentication.Screen>(
				baseScreen: .init(
					username: state.username,
					password: state.password,
					usernameTextEdited: { sink.send(.updateUsername(.init(text: $0))) },
					passwordEdited: { sink.send(.updatePassword($0)) },
					submitTapped: { sink.send(.verifyCredentials) },
					isAuthenticating: state.isAuthenticating,
					hasInvalidUsername: state.hasInvalidUsername,
					hasInvalidPassword: state.hasInvalidPassword
				),
				alert: state.alert
			)
		} running: {
			state.loginWorker.mapSuccess(Action.finish)
			state.verificationWorker.mapSuccess(Action.attemptLogin)
		}
	}
}

// MARK: -
private extension Authentication.Workflow {
	typealias LoginWorker = Worker<(Account, User), Login.Result>
	typealias VerificationWorker = Worker<Credentials, Credentials.Verification.Result>

	enum Action {
		case updateUsername(User.Username)
		case updatePassword(String)
		case verifyCredentials
		case attemptLogin(Credentials.Verification?)
		case finish(Account.Identified.ID?)
	}
}

// MARK: -
extension Authentication.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Authentication.Workflow<LoginService, CredentialsService>

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case let .updateUsername(username):
			state.credentials.username = username
		case let .updatePassword(password):
			state.credentials.password = password
		case .verifyCredentials:
			state.verifyCredentials()
		case let .attemptLogin(verification):
			state.attemptLogin(with: verification)
		case let .finish(accountID):
			return accountID
		}
		return nil
	}
}

// MARK: -
private extension Authentication.Workflow.State {
	var username: User.Username {
		credentials.username
	}

	var password: String {
		credentials.password
	}

	var account: Account {
		.init(password: password)
	}

	var user: User {
		.init(username: username)
	}

	var isAuthenticating: Bool {
		loginWorker.isWorking || verificationWorker.isWorking
	}

	var hasInvalidUsername: Bool {
		invalidUsernames[credentials.password]?.contains(username) ?? false
	}

	var hasInvalidPassword: Bool {
		invalidPasswords[username]?.contains(password) ?? false
	}

	var alert: Alert? {
		let context =
			loginWorker.errorContext ??
			verificationWorker.errorContext
		return context
			.map { ($0.0.message, $0.1) }
			.map(makeAlert)
	}

	func verifyCredentials() {
		verificationWorker.work(with: credentials)
	}

	mutating func attemptLogin(with verification: Credentials.Verification?) {
		switch verification {
		case .match, .creation:
			loginWorker.work(with: (account, user))
		case .mismatch(.username):
			invalidUsernames[password, default: []].append(username)
		case .mismatch(.password):
			invalidPasswords[username, default: []].append(password)
		default:
			break
		}
	}

	func makeAlert(message: String, dismissHandler: @escaping () -> Void) -> Alert {
		let strings = Strings.Alert.self

		return .init(
			title: strings.Error.network,
			message: message,
			actions: [
				.init(
					title: strings.dismiss,
					handler: dismissHandler
				)
			]
		)
	}
}
