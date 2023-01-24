// Copyright © Fleuronic LLC. All rights reserved.

import class Workflow.RenderContext
import struct Model.Todo
import struct Workflow.Sink
import struct Coffin.Identified
import protocol Workflow.Workflow
import protocol Workflow.WorkflowAction

import WorkflowContainers

public extension Todo {
	struct Workflow {
		private let name: String
		private let initialTodos: [Model.Todo.Identified]?
		private let canLogOut: Bool

		public init(
			name: String,
			initialTodos: [Model.Todo.Identified]? = nil,
			canLogOut: Bool = true
		) {
			self.name = name
			self.initialTodos = initialTodos
			self.canLogOut = canLogOut
		}
	}
}

// MARK: -
extension Todo.Workflow {
	enum ListAction {
		case editTodo(index: Int)
		case createTodo
		case deleteTodo(index: Int)
		case logOut
	}

	enum EditAction {
		case saveTodo(Model.Todo.Identified, index: Int)
		case cancel
	}
}

// MARK: -
extension Todo.Workflow: Workflow {
	public typealias Rendering = [BackStackItem]

	public struct State {
		var todos: [Model.Todo.Identified]
		var step: Step
	}
	
	public enum Output {
		case logout
	}

	public func makeInitialState() -> State {
		.init(
			todos: .stored ?? initialTodos ?? [],
			step: .list
		)
	}

	public func render(state: State, context: RenderContext<Todo.Workflow>) -> Rendering {
		let listItem = listItem(with: state, in: context)

		switch state.step {
		case .list:
			return [listItem]
		case let .editTodo(index):
			let editItem = editItem(with: state, in: context, editingTodoAt: index)
			return [listItem, editItem]
		}
	}
}

// MARK: -
private extension Todo.Workflow {
	func listItem(with state: State, in context: RenderContext<Self>) -> BackStackItem {
		Todo.List.Workflow(name: name, todos: state.todos.map(\.value), canLogOut: canLogOut)
			.mapOutput(action)
			.rendered(in: context)
	}

	func editItem(with state: State, in context: RenderContext<Self>, editingTodoAt index: Int) -> BackStackItem {
		Todo.Edit.Workflow(initialTodo: state.todos[index])
			.mapOutput { action(for: $0, editingTodoAt: index) }
			.rendered(in: context)
	}

	func action(for listOutput: Todo.List.Workflow.Output) -> ListAction {
		switch listOutput {
		case let .todoSelection(index: index):
			return .editTodo(index: index)
		case .todoCreation:
			return .createTodo
		case let .todoDeletion(index: index):
			return .deleteTodo(index: index)
		case .logout:
			return .logOut
		}
	}

	func action(for editOutput: Todo.Edit.Workflow.Output, editingTodoAt index: Int) -> EditAction {
		switch editOutput {
		case let .editedTodo(todo):
			return .saveTodo(todo, index: index)
		case .cancellation:
			return .cancel
		}
	}
}

// MARK: -
extension Todo.Workflow.State {
	enum Step {
		case list
		case editTodo(index: Int)
	}
}

// MARK: -
extension Todo.Workflow.ListAction: WorkflowAction {
	typealias WorkflowType = Todo.Workflow

	func apply(toState state: inout Todo.Workflow.State) -> Todo.Workflow.Output? {
		switch self {
		case let .editTodo(index):
			state.step = .editTodo(index: index)
		case .createTodo:
			state.todos.append(Model.Todo.Identified().store())
		case let .deleteTodo(index):
			state.todos.remove(at: index).removeFromStorage()
		case .logOut:
			state.todos.removeFromStorage()
			return .logout
		}
		return nil
	}
}

// MARK: -
extension Todo.Workflow.EditAction: WorkflowAction {
	typealias WorkflowType = Todo.Workflow

	func apply(toState state: inout Todo.Workflow.State) -> Todo.Workflow.Output? {
		switch self {
		case let .saveTodo(todo, index):
			state.todos[index] = todo.store()
			fallthrough
		case .cancel:
			state.step = .list
		}
		return nil
	}
}

// MARK: -
extension Todo.Workflow.State: Equatable {}

// MARK: -
extension Todo.Workflow.State.Step: Equatable {}
