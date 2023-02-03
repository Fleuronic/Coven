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
	public typealias Rendering = AnyScreen
	public typealias Output = Never

	public struct State {}

	public func makeInitialState() -> State {
		.init()
	}

	public func render(state: State, context: RenderContext<Self>) -> Rendering {
		BackStack.Screen(items: [item]).asAnyScreen()
	}
}

// MARK: -
private extension Counter.Workflow {
	var item: BackStack.Item {
		.init(
			screen: Counter.Screen().asAnyScreen(),
			barContent: .init(title: "Counter")
		)
	}
}
