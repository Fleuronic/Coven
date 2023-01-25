// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings
import enum WorkflowContainers.BackStack
import struct Model.Account
import struct Model.User
import struct Model.PhoneNumber
import struct Model.PIN
import struct Coven.API
import struct Ergo.RequestWorker
import struct Workflow.Sink
import struct WorkflowContainers.Alert
import class Workflow.RenderContext
import protocol Workflow.Workflow
import protocol Workflow.WorkflowAction

extension Authentication.Credentials {
	struct Workflow {
		private let api: Coven.API
		private let initialUsername: User.Username
		private let initialPhoneNumber: PhoneNumber

		init(
			api: Coven.API,
			initialUsername: User.Username,
			initialPhoneNumber: PhoneNumber
		) {
			self.api = api
			self.initialUsername = initialUsername
			self.initialPhoneNumber = initialPhoneNumber
		}
	}
}

// MARK: -
extension Authentication.Credentials.Workflow: Workflow {
	typealias Rendering = BackStack.Item
	typealias Output = (Account, PIN)

	struct State {
		var username: User.Username
		var phoneNumber: PhoneNumber
		var invalidPhoneNumbers: [User.Username: [PhoneNumber]] = [:]
		var invalidUsernames: [PhoneNumber: [User.Username]] = [:]
		var credentialsVerificationState: API.Credentials.Verification.State = .idle
	}

	func makeInitialState() -> State {
		.init(
			username: initialUsername,
			phoneNumber: initialPhoneNumber
		)
	}

	func render(state: State, context: RenderContext<Self>) -> Rendering {
		context.run(
			state
				.credentialsVerificationWorker(using: api)?
				.mapOutput(Action.finishCredentialsVerification)
		)

		return .init(
			screen: screen(
				state: state,
				sink: context.makeSink(of: Action.self)
			).asAnyScreen()
		)
	}
}

// MARK: -
extension Authentication.Credentials.Workflow {
	enum Action: WorkflowAction {
		case updateUsername(User.Username)
		case updatePhoneNumber(PhoneNumber)
		case verifyCredentials
		case finishCredentialsVerification(API.Credentials.Verification.Result)
		case dismissAlert
	}
}

// MARK: -
private extension Authentication.Credentials.Workflow {
	func screen(state: State, sink: Sink<Action>) -> Alert.Screen<Authentication.Credentials.Screen> {
		.init(
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
	}
}

// MARK: -
extension Authentication.Credentials.Workflow.Action {
	typealias WorkflowType = Authentication.Credentials.Workflow

	func apply(toState state: inout Authentication.Credentials.Workflow.State) -> Authentication.Credentials.Workflow.Output? {
		switch self {
		case let .updateUsername(username):
			state.username = username
		case let .updatePhoneNumber(phoneNumber):
			state.phoneNumber = phoneNumber
		case .verifyCredentials:
			state.credentialsVerificationState = .requesting
		case let .finishCredentialsVerification(.success(verification)):
			state.credentialsVerificationState = .retrieved(verification)
			switch verification {
			case .match, .creation:
				return (state.account, .empty)
			case let .mismatch(mismatch):
				state.handle(mismatch)
			}
		case let .finishCredentialsVerification(.failure(error)):
			state.credentialsVerificationState = .failed(error)
		case .dismissAlert:
			state.credentialsVerificationState = .idle
		}
		return nil
	}
}

// MARK: -
private extension Authentication.Credentials.Workflow.State {
	var account: Account {
		.init(
			phoneNumber: phoneNumber
		)
	}

	var isVerifyingCredentials: Bool {
		credentialsVerificationState.isRequesting
	}

	var hasInvalidUsername: Bool {
		invalidUsernames[phoneNumber]?.contains(username) ?? false
	}

	var hasInvalidPhoneNumber: Bool {
		invalidPhoneNumbers[username]?.contains(phoneNumber) ?? false
	}

	func credentialsVerificationWorker(using api: API) -> RequestWorker<API.Credentials.Verification.Result>? {
		credentialsVerificationState.mapRequesting(
			.init {
				await api.verifyCredentials(
					username: username,
					phoneNumber: phoneNumber 
				)
			}
		)
	}

	func alert(dismissHandler: @escaping () -> Void) -> Alert? {
		let strings = Strings.Alert.self
		return credentialsVerificationState.mapError { error in
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

	mutating func handle(_ mismatch: API.Credentials.Verification.Mismatch) {
		switch mismatch {
		case .username:
			invalidUsernames[phoneNumber, default: []].append(username)
		case .phoneNumber:
			invalidPhoneNumbers[username, default: []].append(phoneNumber)
		}
	}
}
