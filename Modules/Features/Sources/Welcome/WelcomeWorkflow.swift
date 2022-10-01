// Copyright © Fleuronic LLC. All rights reserved.


import enum EmailableAPI.Emailable
import struct Model.User
import struct Ergo.RequestWorker
import struct Ergo.DelayedWorker
import struct Workflow.Sink
import class Workflow.RenderContext
import protocol Workflow.Workflow
import protocol Workflow.WorkflowAction

public extension Welcome {
	struct Workflow {
		private let api: Emailable.API
		private let initialName: String
		private let initialEmail: String

		public init(
			api: Emailable.API,
			initialName: String? = nil,
			initialEmail: String? = nil
		) {
			self.api = api
			self.initialName = initialName ?? ""
			self.initialEmail = initialEmail ?? ""
		}
	}
}

// MARK: -
extension Welcome.Workflow: Workflow {
	public typealias Rendering = Welcome.Screen

	public struct State {
		var name: String
		var email: String
		var invalidEmails: [String] = []
		var emailVerificationState: Emailable.Email.Verification.State = .idle
	}

	public enum Output {
		case user(User)
	}

	public func makeInitialState() -> State {
		.init(
			name: initialName,
			email: initialEmail
		)
	}

	public func render(state: State, context: RenderContext<Self>) -> Rendering {
		context.run(
			state
				.emailVerificationWorker(using: api)?
				.mapOutput(Action.finishEmailVerification),
			state
				.emailVerificationResetWorker?
				.mapOutput(Action.resetEmailVerification)
		)

		return screen(
			state: state,
			sink: context.makeSink(of: Action.self)
		)
	}
}

// MARK: -
extension Welcome.Workflow {
	enum Action: WorkflowAction {
		case updateName(String)
		case updateEmail(String)
		case verifyEmail
		case finishEmailVerification(Emailable.Email.Verification.Result)
		case resetEmailVerification(Void)
	}
}

// MARK: -
private extension Welcome.Workflow {
	func screen(state: State, sink: Sink<Action>) -> Welcome.Screen {
		.init(
			name: state.name,
			email: state.email,
			isVerifyingEmail: state.isVerifyingEmail,
			hasInvalidEmail: state.hasInvalidEmail,
			errorMessage: state.errorMessage,
			nameTextEdited: { sink.send(.updateName($0)) },
			emailTextEdited: { sink.send(.updateEmail($0)) },
			loginTapped: { sink.send(.verifyEmail) }
		)
	}
}

// MARK: -
extension Welcome.Workflow.Action {
	typealias WorkflowType = Welcome.Workflow

	func apply(toState state: inout Welcome.Workflow.State) -> Welcome.Workflow.Output? {
		switch self {
		case let .updateName(name):
			state.name = name
		case let .updateEmail(email):
			state.email = email
			fallthrough
		case .resetEmailVerification:
			state.emailVerificationState = .idle
		case .verifyEmail:
			state.emailVerificationState = .requesting
		case let .finishEmailVerification(.success(verification)) where
			verification.reason == .acceptedEmail:
			state.emailVerificationState = .retrieved(verification)
			return .user(state.user.store())
		case let .finishEmailVerification(.success(verification)) where verification.reason == .invalidDomain:
			state.invalidEmails.append(verification.email)
			state.emailVerificationState = .retrieved(verification)
		case let .finishEmailVerification(.failure(error)):
			state.emailVerificationState = .failed(error)
		default:
			break
		}
		return nil
	}
}

// MARK: -
private extension Welcome.Workflow.State {
	var user: User {
		.init(
			name: name,
			email: email
		)
	}

	var isVerifyingEmail: Bool {
		emailVerificationState.isRequesting
	}

	var hasInvalidEmail: Bool {
		invalidEmails.contains(email.lowercased())
	}

	var errorMessage: String? {
		emailVerificationState.mapError(\.message)
	}

	var emailVerificationResetWorker: DelayedWorker? {
		emailVerificationState.mapError(.init(delay: .reset))
	}

	func emailVerificationWorker(using api: Emailable.API) -> RequestWorker<Emailable.Email.Verification.Result>? {
		emailVerificationState.mapRequesting(.init { await api.verify(email) })
	}
}

// MARK: -
extension Welcome.Workflow.Output: Equatable {}
