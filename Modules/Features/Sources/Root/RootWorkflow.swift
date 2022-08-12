// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import BackStackContainer
import Welcome
import Todo

import enum EmailableAPI.Emailable

public extension Root {
	struct Workflow {
		private let api: Emailable.API

		public init(api: Emailable.API) {
			self.api = api
		}
	}
}

// MARK: -
extension Root.Workflow {
	enum Action {
		case logIn(name: String)
		case logOut
	}
}

// MARK: -
extension Root.Workflow: Workflow {
	public typealias Rendering = BackStackScreen<AnyScreen>

	public enum State {
		case welcome
		case todo(name: String)
	}

	public func makeInitialState() -> State {
		.welcome
	}

	public func render(state: State, context: RenderContext<Self>) -> Rendering {
		let welcomeItem = welcomeItem(in: context)

		switch state {
		case .welcome:
			return .init(items: [welcomeItem])
		case let .todo(name):
			let todoItems = todoItems(with: name, in: context)
			return .init(items: [welcomeItem] + todoItems)
		}
	}
}

// MARK: -
private extension Root.Workflow {
	func welcomeItem(in context: RenderContext<Self>) -> BackStackItem {
		.init(
			screen: Welcome.Workflow(api: api)
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

	func action(for welcomeOutput: Welcome.Workflow.Output) -> Action {
		switch welcomeOutput {
		case let .user(name):
			return .logIn(name: name)
		}
	}

	func action(for todoOutput: Todo.Workflow.Output) -> Action {
		switch todoOutput {
		case .end:
			return .logOut
		}
	}
}

// MARK: -
extension Root.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Root.Workflow

	func apply(toState state: inout Root.Workflow.State) -> Never? {
		switch self {
		case let .logIn(name):
			state = .todo(name: name)
		case .logOut:
			state = .welcome
		}
		return nil
	}
}

// MARK: -
extension Root.Workflow.State: Equatable {}
