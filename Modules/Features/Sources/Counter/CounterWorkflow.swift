// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import Ergo

public extension Counter {
	struct Workflow {
		public init() {}
	}
}

// MARK: -
extension Counter.Workflow: Workflow {
	public typealias Output = Void

	public func makeInitialState() -> Int {
		0
	}

	public func render(state: Int, context: RenderContext<Self>) -> AnyScreen {
		context.render { (sink: Sink<Action>) in
			BackStack.Screen(
				items: [
					.init(
						screen: Counter.Screen(
							value: state,
							increment: { sink.send(.increment) },
							decrement: { sink.send(.decrement) }
						),
						barContent: .init(
							title: "Counter",
							rightItem: .init(
								content: .text("Log Out"),
								handler: { sink.send(.finish) }
							)
						)
					)
				]
			)
		}
	}
}

// MARK: -
private extension Counter.Workflow {
	enum Action {
		case increment
		case decrement
		case finish
	}
}

// MARK: -
extension Counter.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Counter.Workflow

	func apply(toState state: inout Int) -> Void? {
		switch self {
		case .increment:
			state += 1
		case .decrement:
			state -= 1
		case .finish:
			return ()
		}
		return nil
	}
}