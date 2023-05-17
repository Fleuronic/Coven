// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import EnumKit

import enum Models.Demo
import enum Counter.Counter

public extension Root {
	struct Workflow {
		public init() {}
	}
}

// MARK: -
extension Root.Workflow {
	enum Action: CaseAccessible {
		case demo(Demo)
		case finishDemo
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
					.init(
						screen: Root.Screen(
							selectedDemo: selectedDemo,
							demoSelected: { demo in
								demo.map { sink.send(.demo($0)) }
							}
						).asAnyScreen(),
						barContent: .init(title: "Workflow Demo")
					),
					selectedDemo
						.map(screenWrapper)
						.map(Counter.Workflow.init)?
						.mapOutput { Action.finishDemo }
						.rendered(in: context)
				]
			)
		}
	}
}

private extension Root.Workflow {
	func screenWrapper(for demo: Demo) -> (Counter.Screen) -> AnyScreen {
		switch demo {
		case .swiftUI:
			return Counter.SwiftUI.Screen.wrap
		case .uiKit(false):
			return Counter.UIKit.Screen.wrap
		case .uiKit(true):
			return Counter.DeclarativeUIKit.Screen.wrap
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