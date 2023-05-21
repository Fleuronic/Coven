// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import WorkflowTesting

import enum Demo.Demo

@testable import WorkflowContainers
@testable import enum Counter.Counter
@testable import struct WorkflowUI.AnyScreen

final class CounterWorkflowRenderingTests: XCTestCase {
	func testRenderingScreen() throws {
		try Counter.Workflow(
			demo: .swiftUI,
			screenWrapper: Counter.SwiftUI.Screen.wrap
		)
		.renderTester()
		.render { item in
			let screen = try XCTUnwrap(item.screen.wrappedScreen as? Counter.SwiftUI.Screen)
			XCTAssertEqual(screen.valueText, "The value is 0")
			XCTAssertEqual(screen.incrementTitle, "+")
			XCTAssertEqual(screen.decrementTitle, "-")
		}
	}

	func testRenderingBarContent() throws {
		Counter.Workflow(
			demo: .swiftUI,
			screenWrapper: Counter.SwiftUI.Screen.wrap
		)
		.renderTester()
		.render { item in
			switch item.barVisibility {
			case let .visible(barContent):
				XCTAssertEqual(barContent.title, "SwiftUI Counter Demo")
			default:
				XCTFail()
			}
		}

		try Counter.Workflow(
			demo: .uiKit(declarative: false),
			screenWrapper: Counter.UIKit.Screen.wrap
		)
		.renderTester()
		.render { item in
			let screen = try XCTUnwrap(item.screen.wrappedScreen as? Counter.UIKit.Screen)
			XCTAssertEqual(screen.value, 0)

			switch item.barVisibility {
			case let .visible(barContent):
				XCTAssertEqual(barContent.title, "UIKit Counter Demo")
			default:
				XCTFail()
			}
		}

		try Counter.Workflow(
			demo: .uiKit(declarative: true),
			screenWrapper: Counter.DeclarativeUIKit.Screen.wrap
		)
		.renderTester()
		.render { item in
			let screen = try XCTUnwrap(item.screen.wrappedScreen as? Counter.DeclarativeUIKit.Screen)
			XCTAssertEqual(screen.value, 0)

			switch item.barVisibility {
			case let .visible(barContent):
				XCTAssertEqual(barContent.title, "Declarative UIKit Counter Demo")
			default:
				XCTFail()
			}
		}
	}

	func testRenderingIncrement() throws {
		try Counter.Workflow(
			demo: .swiftUI,
			screenWrapper: Counter.SwiftUI.Screen.wrap
		)
		.renderTester()
		.render { item in
			let screen = try XCTUnwrap(item.screen.wrappedScreen as? Counter.SwiftUI.Screen)
			screen.increment()
		}
		.assert(state: 1)
		.assertNoOutput()
	}

	func testRenderingDecrement() throws {
		try Counter.Workflow(
			demo: .swiftUI,
			screenWrapper: Counter.SwiftUI.Screen.wrap
		)
		.renderTester()
		.render { item in
			let screen = try XCTUnwrap(item.screen.wrappedScreen as? Counter.SwiftUI.Screen)
			screen.decrement()
		}
		.assert(state: -1)
		.assertNoOutput()
	}

	func testRenderingReset() throws {
		Counter.Workflow(
			demo: .swiftUI,
			screenWrapper: Counter.SwiftUI.Screen.wrap
		)
		.renderTester()
		.render { item in
			switch item.barVisibility {
			case let .visible(barContent):
				barContent.rightItem?.handler()
			default:
				XCTFail()
			}
		}
		.assert(action: Counter.Workflow.Action.reset)
		.assertNoOutput()
	}

	func testRenderingFinish() throws {
		Counter.Workflow(
			demo: .swiftUI,
			screenWrapper: Counter.SwiftUI.Screen.wrap
		)
		.renderTester()
		.render { item in
			switch item.barVisibility {
			case let .visible(barContent):
				barContent.leftItem?.handler()
			default:
				XCTFail()
			}
		}
		.assert(action: Counter.Workflow.Action.finish)
		.verifyOutput { XCTAssert($0 == ()) }
	}
}
