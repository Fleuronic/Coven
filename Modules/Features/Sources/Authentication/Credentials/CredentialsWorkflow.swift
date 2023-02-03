// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowContainers
import Ergo

import enum Assets.Strings
import struct Coven.Credentials
import struct Coven.User
import struct Coven.PhoneNumber
import protocol CovenService.CredentialsSpec

extension Authentication.Credentials {
	struct Workflow<Service: CredentialsSpec> where Service.VerificationResult == Credentials.Verification.Result {
		private let initialUsername: User.Username
		private let initialPhoneNumber: PhoneNumber
		private let needsPhoneNumberReinput: Bool
		private let service: Service

		init(
			initialUsername: User.Username,
			initialPhoneNumber: PhoneNumber,
			needsPhoneNumberReinput: Bool,
			service: Service
		) {
			self.initialUsername = initialUsername
			self.initialPhoneNumber = initialPhoneNumber
			self.needsPhoneNumberReinput = needsPhoneNumberReinput
			self.service = service
		}
	}
}

// MARK: -
extension Authentication.Credentials.Workflow: Workflow {
	typealias Rendering = BackStack.Item
	typealias Output = Credentials

	struct State {
		var username: User.Username
		var phoneNumber: PhoneNumber
		var invalidPhoneNumbers: [User.Username: [PhoneNumber]] = [:]
		var invalidUsernames: [PhoneNumber: [User.Username]] = [:]
		var verificationState: Verification.State = .idle
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
				.verificationWorker(using: service)?
				.mapOutput(Action.finishVerification)
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
	enum Action {
		case updateUsername(User.Username)
		case updatePhoneNumber(PhoneNumber)
		case verify
		case finishVerification(State.Verification.Result)
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
				submitTapped: { sink.send(.verify) },
				isVerifyingCredentials: state.isVerifyingCredentials,
				hasInvalidUsername: state.hasInvalidUsername,
				hasInvalidPhoneNumber: state.hasInvalidPhoneNumber,
				needsPhoneNumberReinput: needsPhoneNumberReinput
			),
			alert: state.alert {
				sink.send(.dismissAlert)
			}
		)
	}
}

// MARK: -
extension Authentication.Credentials.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Authentication.Credentials.Workflow<Service>

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
				return state.credentials
			case let .mismatch(mismatch):
				state.handle(mismatch)
			}
		case let .finishVerification(.failure(error)):
			state.verificationState = .failed(error)
		case .dismissAlert:
			state.verificationState = .idle
		}
		return nil
	}
}

// MARK: -
extension Authentication.Credentials.Workflow.State {
	typealias Verification = Credentials.Verification
}

// MARK: -
private extension Authentication.Credentials.Workflow.State {
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

	func verificationWorker(using service: Service) -> RequestWorker<Verification.Result>? {
		verificationState.mapRequesting(
			.init {
				await service.verifyCredentials(
					username: username,
					phoneNumber: phoneNumber 
				)
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

	mutating func handle(_ mismatch: Verification.Mismatch) {
		switch mismatch {
		case .username:
			invalidUsernames[phoneNumber, default: []].append(username)
		case .phoneNumber:
			invalidPhoneNumbers[username, default: []].append(phoneNumber)
		}
	}
}
