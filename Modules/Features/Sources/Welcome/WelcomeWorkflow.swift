// Copyright © Fleuronic LLC. All rights reserved.

import struct Model.User
import struct Model.PhoneNumber
import struct Ergo.RequestWorker
import struct Ergo.DelayedWorker
import struct Workflow.Sink
import class Workflow.RenderContext
import protocol Workflow.Workflow
import protocol Workflow.WorkflowAction

public extension Welcome {
	struct Workflow {
		private let initialUsername: User.Username
		private let initialPhoneNumber: PhoneNumber

		public init(
			initialUsername: User.Username? = nil,
			initialPhoneNumber: PhoneNumber? = nil
		) {
			self.initialUsername = initialUsername ?? .empty
			self.initialPhoneNumber = initialPhoneNumber ?? .empty
		}
	}
}

// MARK: -
extension Welcome.Workflow: Workflow {
	public typealias Rendering = Welcome.Screen

	public struct State {
		var username: User.Username
		var phoneNumber: PhoneNumber
	}

	public enum Output {
		case user(User)
	}

	public func makeInitialState() -> State {
		.init(
			username: initialUsername,
			phoneNumber: initialPhoneNumber
		)
	}

	public func render(state: State, context: RenderContext<Self>) -> Rendering {
		screen(
			state: state,
			sink: context.makeSink(of: Action.self)
		)
	}
}

// MARK: -
extension Welcome.Workflow {
	enum Action: WorkflowAction {
		case updateUsername(User.Username)
		case updatePhoneNumber(PhoneNumber)
	}
}

// MARK: -
private extension Welcome.Workflow {
	func screen(state: State, sink: Sink<Action>) -> Welcome.Screen {
		.init(
			username: state.username,
			phoneNumber: state.phoneNumber,
			usernameTextEdited: { sink.send(.updateUsername(.init(text: $0))) },
			phoneNumberTextEdited: { sink.send(.updatePhoneNumber(.init(text: $0))) },
			submitTapped: {}
		)
	}
}

// MARK: -
extension Welcome.Workflow.Action {
	typealias WorkflowType = Welcome.Workflow

	func apply(toState state: inout Welcome.Workflow.State) -> Welcome.Workflow.Output? {
		switch self {
		case let .updateUsername(username):
			state.username = username
		case let .updatePhoneNumber(phoneNumber):
			state.phoneNumber = phoneNumber
		}
		return nil
	}
}

// MARK: -
private extension Welcome.Workflow.State {
	var user: User {
		.init(
			username: username,
			phoneNumber: phoneNumber
		)
	}
}

// MARK: -
extension Welcome.Workflow.Output: Equatable {}
