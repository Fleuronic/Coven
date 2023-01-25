// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings
import enum WorkflowContainers.BackStack
import struct Model.PIN
import struct Coven.API
import struct Ergo.RequestWorker
import struct Workflow.Sink
import struct WorkflowContainers.Alert
import class Workflow.RenderContext
import protocol Workflow.Workflow
import protocol Workflow.WorkflowAction

extension Authentication.PIN {
	struct Workflow {
		private let api: API
		private let pin: PIN

		init(
			api: API,
			pin: PIN
		) {
			self.api = api
			self.pin = pin
		}
	}
}

// MARK: -
extension Authentication.PIN.Workflow: Workflow {
	typealias Rendering = BackStack.Item

	enum Output {
		case confirmation
		case cancellation
	}

	struct State {
		var pin: PIN
	}

	func makeInitialState() -> State {
		.init(
			pin: .empty
		)
	}

	func render(state: State, context: RenderContext<Self>) -> Rendering {
		item(
			state: state,
			sink: context.makeSink(of: Action.self)
		)
	}
}

// MARK: -
extension Authentication.PIN.Workflow {
	enum Action: WorkflowAction {
		case confirm(PIN)
		case cancel
	}
}

// MARK: -
private extension Authentication.PIN.Workflow {
	func screen(state: State, sink: Sink<Action>) -> Authentication.PIN.Screen {
		.init()
	}

	func item(state: State, sink: Sink<Action>) -> BackStack.Item {
		.init(
			screen: screen(
				state: state,
				sink: sink
			).asAnyScreen(),
			barContent: .init(
				title: "Verify PIN",
				leftItem: .init(
					content: .back(title: "Credentials"),
					handler: { sink.send(.cancel) }
				)
			)
		)
	}
}

// MARK: -
extension Authentication.PIN.Workflow.Action {
	typealias WorkflowType = Authentication.PIN.Workflow

	func apply(toState state: inout Authentication.PIN.Workflow.State) -> Authentication.PIN.Workflow.Output? {
		switch self {
		case .confirm:
			return .confirmation
		case .cancel:
			return .cancellation
		}
	}
}
