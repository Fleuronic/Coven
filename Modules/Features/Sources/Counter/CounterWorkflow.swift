// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers

import enum Demo.Demo

public extension Counter {
	struct Workflow {
		private let demo: Demo
		private let screenWrapper: (Counter.Screen) -> AnyScreen

		public init(demo: Demo) {
			self.demo = demo

			switch demo {
			case .swiftUI:
				screenWrapper = Counter.SwiftUI.Screen.wrap
			case .uiKit(false):
				screenWrapper = Counter.UIKit.Screen.wrap
			case .uiKit(true):
				screenWrapper = Counter.DeclarativeUIKit.Screen.wrap
			}
		}
	}
}

// MARK: -
extension Counter.Workflow: Workflow {
	public typealias Output = Void

	public func makeInitialState() -> Int { 0 }

	public func render(
		state value: Int,
		context: RenderContext<Self>
	) -> BackStack.Item {
		context.render { (sink: Sink<Action>) in
			.init(
				screen: screenWrapper(
					.init(
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
						isEnabled: value != 0,
						handler: { sink.send(.reset) }
					)
				)
			)
		}
	}
}

// MARK: -
extension Counter.Workflow {
	enum Action {
		case increment
		case decrement
		case reset
		case finish
	}
}

// MARK: -
private extension Counter.Workflow {
	var title: String {
		"\(demo.name) Counter Demo"
	}
}

// MARK: -
extension Counter.Workflow.Action: WorkflowAction {
	// MARK: WorkflowAction
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
