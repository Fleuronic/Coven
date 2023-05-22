// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import EnumKit

import enum Demo.Demo

public extension DemoList {
	struct Workflow {
		public init() {}
	}
}

// MARK: -
extension DemoList.Workflow {
	enum Action: CaseAccessible, Equatable {
		case demo(Demo)
	}
}

// MARK: -
extension DemoList.Workflow: Workflow {
	public typealias Output = Demo

	public func render(
		state: Void,
		context: RenderContext<Self>
	) -> BackStack.Item {
		context.render { (sink: Sink<Action>) in
			.init(
				screen: DemoList.Screen { sink.send(.demo($0)) }.asAnyScreen(),
				barContent: .init(title: "Workflow Demo")
			)
		}
	}
}

// MARK: -
extension DemoList.Workflow.Action: WorkflowAction {
	public typealias WorkflowType = DemoList.Workflow

	public func apply(toState state: inout Void) -> Demo? {
		associatedValue()
	}
}
