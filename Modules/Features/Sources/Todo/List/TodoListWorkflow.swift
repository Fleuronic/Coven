// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings
import struct Model.Todo
import struct Workflow.Sink
import class Workflow.RenderContext
import protocol Workflow.Workflow
import protocol Workflow.WorkflowAction

import BackStackContainer

extension Todo.List {
	struct Workflow {
		private let name: String
		private let todos: [Model.Todo]
		private let canLogOut: Bool

		init(
			name: String,
			todos: [Model.Todo],
			canLogOut: Bool
		) {
			self.name = name
			self.todos = todos
			self.canLogOut = canLogOut
		}
	}
}

// MARK: -
extension Todo.List.Workflow {
	enum Action: WorkflowAction {
		case selectTodo(index: Int)
		case createTodo
		case deleteTodo(index: Int)
		case logOut
	}
}

// MARK: -
extension Todo.List.Workflow: Workflow {
	typealias Rendering = BackStackItem

	struct State {}

	enum Output {
		case todoSelection(index: Int)
		case todoCreation
		case todoDeletion(index: Int)
		case logout
	}

	func makeInitialState() -> State {
		.init()
	}

	func render(state: State, context: RenderContext<Self>) -> Rendering {
		item(
			state: state,
			sink: context.makeSink(of: Action.self)
		)
	}
}

// MARK: -
private extension Todo.List.Workflow {
	func screen(state: State, sink: Sink<Action>) -> Todo.List.Screen {
		.init(
			todoTitles: todos.map(\.title),
			rowSelected: { sink.send(.selectTodo(index: $0)) },
			rowDeleted: { sink.send(.deleteTodo(index: $0)) }
		)
	}

	func item(state: State, sink: Sink<Action>) -> BackStackItem {
		.init(
			screen: screen(state: state, sink: sink).asAnyScreen(),
			barContent: .init(
				title: Strings.Todo.List.title(name),
				leftItem: .init(content: .text("Log Out"), isEnabled: canLogOut) { sink.send(.logOut) },
				rightItem: .init(content: .text(Strings.Todo.List.Title.Button.newTodo)) { sink.send(.createTodo) }
			)
		)
	}
}

// MARK: -
extension Todo.List.Workflow.State {
	enum Step {
		case list
		case editTodo(index: Int)
	}
}

// MARK: -
extension Todo.List.Workflow.Action {
	typealias WorkflowType = Todo.List.Workflow

	func apply(toState state: inout Todo.List.Workflow.State) -> Todo.List.Workflow.Output? {
		switch self {
		case let .selectTodo(index):
			return .todoSelection(index: index)
		case .createTodo:
			return .todoCreation
		case let .deleteTodo(index):
			return .todoDeletion(index: index)
		case .logOut:
			return .logout
		}
	}
}

// MARK: -
extension Todo.List.Workflow.Output: Equatable {}
