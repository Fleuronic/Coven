// Copyright © Fleuronic LLC. All rights reserved.

import enum Authentication.Authentication
import enum Todo.Todo
import enum API.Coven
import class Workflow.RenderContext
import struct Model.User
import struct WorkflowUI.AnyScreen
import protocol Workflow.Workflow
import protocol Workflow.WorkflowAction

import WorkflowContainers

public extension Root {
	struct Workflow {
		private let api: Coven.API

		public init(api: Coven.API) {
			self.api = api
		}
	}
}

// MARK: -
extension Root.Workflow {
	enum Action {
		case logIn(User)
		case logOut
	}
}

// MARK: -
extension Root.Workflow: Workflow {
	public typealias Rendering = BackStack.Screen<AnyScreen>

	public enum State {
		case authentication
		case todo(name: String)
	}

	public func makeInitialState() -> State {
		(User.stored?.name).map(State.todo) ?? .authentication
	}

	public func render(state: State, context: RenderContext<Self>) -> Rendering {
		let authenticationItem = authenticationItem(in: context)

		switch state {
		case .authentication:
			return .init(items: [authenticationItem])
		case let .todo(name):
			let todoItems = todoItems(with: name, in: context)
			return .init(items: [authenticationItem] + todoItems)
		}
	}
}

// MARK: -
private extension Root.Workflow {
	func authenticationItem(in context: RenderContext<Self>) -> BackStackItem {
		.init(
			screen: Authentication.Workflow(api: api)
				.mapOutput(action)
				.rendered(in: context)
				.asAnyScreen(),
			barVisibility: .hidden
		)
	}

	func todoItems(with name: String, in context: RenderContext<Self>) -> [BackStackItem] {
		Todo.Workflow(name: name)
			.mapOutput(action)
			.rendered(in: context)
	}

	func action(for authenticationOutput: Authentication.Workflow.Output) -> Action {
		switch authenticationOutput {
		case let .user(user):
			return .logIn(user)
		}
	}

	func action(for todoOutput: Todo.Workflow.Output) -> Action {
		switch todoOutput {
		case .logout:
			return .logOut
		}
	}
}

// MARK: -
extension Root.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Root.Workflow

	func apply(toState state: inout Root.Workflow.State) -> Never? {
		switch self {
		case let .logIn(user):
			state = .todo(name: user.name)
		case .logOut:
			User.removeFromStorage()
			state = .authentication
		}
		return nil
	}
}

// MARK: -
extension Root.Workflow.State: Equatable {}
