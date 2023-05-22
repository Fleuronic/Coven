// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import WorkflowTesting
import EnumKit

import enum Demo.Demo

@testable import WorkflowContainers
@testable import enum DemoList.DemoList
@testable import struct WorkflowUI.AnyScreen

final class DemoListWorkflowRenderingTests: XCTestCase {
	func testRenderingScreen() throws {
		let swiftUIDemo = Demo.swiftUI
		let uiKitDemo = Demo.uiKit(declarative: false)
		let declarativeUIKitDemo = Demo.uiKit(declarative: true)
		let demos = [swiftUIDemo, uiKitDemo, declarativeUIKitDemo]

		try DemoList.Workflow()
			.renderTester()
			.render { item in
				let screen = try XCTUnwrap(item.screen.wrappedScreen as? DemoList.Screen)
				XCTAssertEqual(screen.demos, demos)
			}
	}

	func testRenderingBarContent() throws {
		try DemoList.Workflow()
			.renderTester()
			.render { item in
				let barContent = try XCTUnwrap(item.barVisibility[expecting: Bar.Content.self])
				XCTAssertEqual(barContent.title, "Workflow Demo")
			}
	}

	func testRenderingSelectDemo() throws {
		let demo = Demo.swiftUI

		DemoList.Workflow()
			.renderTester()
			.render { ($0.screen.wrappedScreen as? DemoList.Screen)?.selectDemo(demo) }
			.assert(action: DemoList.Workflow.Action.demo(demo))
	}
}

// MARK: -
extension Bar.Visibility: CaseAccessible {}
