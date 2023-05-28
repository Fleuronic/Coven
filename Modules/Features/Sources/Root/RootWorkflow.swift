// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import EnumKit

import enum Demo.Demo
import enum DemoList.DemoList
import enum Counter.Counter

public enum Root {}

// MARK: -
public extension Root {
	struct Workflow {
		public init() {}
	}
}

// MARK: -
extension Root.Workflow {
	enum Action: CaseAccessible, Equatable {
		case showDemoList
		case showCounterDemo(Demo)
	}
}

// MARK: -
extension Root.Workflow: Workflow {
	public func makeInitialState() -> Demo? { nil }

	public func render(
		state selectedDemo: Demo?,
		context: RenderContext<Self>
	) -> BackStack.Screen<AnyScreen> {
		context.render { (sink: Sink<Action>) in
			.init(
				items: [
                    DemoList.Workflow()
						.mapOutput(Action.showCounterDemo)
						.rendered(in: context),
					selectedDemo
						.map(Counter.Workflow.init)?
						.mapOutput { Action.showDemoList }
						.rendered(in: context)
				]
			)
		}
	}
}

// MARK: -
extension Root.Workflow.Action: WorkflowAction {
	public typealias WorkflowType = Root.Workflow

	public func apply(toState selectedDemo: inout Demo?) -> Never? {
		selectedDemo = associatedValue()
		return nil
	}
}
