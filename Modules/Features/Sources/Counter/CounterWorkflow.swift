// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import Ergo

import enum Models.Demo

public extension Counter {
	struct Workflow {
		private let demo: Demo
		private let screenWrapper: ScreenWrapper

		public init(
			demo: Demo,
			screenWrapper: @escaping ScreenWrapper
		) {
			self.demo = demo
			self.screenWrapper = screenWrapper
		}
	}
}

// MARK: -
extension Counter.Workflow: Workflow {
	public typealias Output = Void
	public typealias ScreenWrapper = (Counter.Screen) -> AnyScreen

	public func makeInitialState() -> Int { 0 }

	public func render(
		state value: Int,
		context: RenderContext<Self>
	) -> BackStack.Item {
		context.render { (sink: Sink<Action>) in
			.init(
				screen: screenWrapper(
					Counter.Screen(
						value: value,
						increment: { sink.send(.increment) },
						decrement: { sink.send(.decrement) }
					)
				),
				barContent: .init(
					title: title,
					leftItem: .init(
						content: .back(title: nil),
						handler: { sink.send(.finish) }
					),
					rightItem: .init(
						content: .text("Reset"),
						handler: { sink.send(.reset) }
					)
				)
			)
		}
	}
}

// MARK: -
private extension Counter.Workflow {
	enum Action {
		case increment
		case decrement
		case reset
		case finish
	}

	var title: String {
		"\(demo.name) Counter Demo"
	}
}

// MARK: -
extension Counter.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Counter.Workflow

	func apply(toState value: inout Int) -> Void? {
		switch self {
		case .increment:
			value += 1
		case .decrement:
			value -= 1
		case .reset:
			value = 0
		case .finish:
			return ()
		}
		return nil
	}
}
