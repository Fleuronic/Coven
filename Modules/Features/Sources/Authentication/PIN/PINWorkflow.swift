// Copyright © Fleuronic LLC. All rights reserved.

import Ergo
import Catenoid
import Schemata
import PersistDB
import Coven
import Model
import Workflow
import WorkflowContainers

extension Authentication.PIN {
	struct Workflow {
		private let api: Coven.API
		private let pin: String

		init(
			api: Coven.API,
			pin: String
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
		var pin: String
	}

	func makeInitialState() -> State {
		.init(
			pin: .init()
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
		case confirm(String)
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
