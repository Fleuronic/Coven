// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import BackStackContainer

import struct Model.Todo
import enum Assets.Strings

extension Todo.Edit {
	struct Workflow {
		let initialTodo: Model.Todo
	}
}

// MARK: -
extension Todo.Edit.Workflow {
	enum Action {
		case updateTitle(String)
		case updateNote(String)
		case saveChanges
		case discardChanges
	}
}

// MARK: -
extension Todo.Edit.Workflow: Workflow {
	typealias Rendering = BackStackItem

	struct State {
		var todo: Model.Todo
	}

	enum Output {
		case editedTodo(Model.Todo)
		case cancellation
	}

	func makeInitialState() -> State {
		.init(todo: initialTodo)
	}

	func render(state: State, context: RenderContext<Self>) -> Rendering {
		item(
			state: state,
			sink: context.makeSink(of: Action.self)
		)
	}
}

// MARK: -
private extension Todo.Edit.Workflow {
	func screen(state: State, sink: Sink<Action>) -> Todo.Edit.Screen {
		.init(
			title: state.todo.title,
			note: state.todo.note,
			titleTextEdited: { sink.send(.updateTitle($0)) },
			noteTextEdited: { sink.send(.updateNote($0)) }
		)
	}

	func item(state: State, sink: Sink<Action>) -> BackStackItem {
		.init(
			screen: screen(state: state, sink: sink).asAnyScreen(),
			barContent: .init(
				title: Strings.Todo.Edit.title,
				leftItem: .button(
					.back { sink.send(.discardChanges) }
				),
				rightItem: .button(
					.init(
						content: .text(Strings.Todo.Edit.Title.Button.save),
						isEnabled: state.todo != initialTodo && !state.todo.title.isEmpty
					) {
						sink.send(.saveChanges)
					}
				)
			)
		)
	}
}

// MARK: -
extension Todo.Edit.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Todo.Edit.Workflow

	func apply(toState state: inout Todo.Edit.Workflow.State) -> Todo.Edit.Workflow.Output? {
		switch self {
		case let .updateTitle(title):
			state.todo.title = title
		case let .updateNote(note):
			state.todo.note = note
		case .saveChanges:
			return .editedTodo(state.todo)
		case .discardChanges:
			return .cancellation
		}
		return nil
	}
}

// MARK: -
extension Todo.Edit.Workflow.Output: Equatable {}
