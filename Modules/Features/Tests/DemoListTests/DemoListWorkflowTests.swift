// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import WorkflowTesting
import EnumKit

import enum Demo.Demo

@testable import WorkflowContainers
@testable import WorkflowReactiveSwift
@testable import enum DemoList.DemoList
@testable import struct WorkflowUI.AnyScreen

final class DemoListWorkflowTests: XCTestCase {
	func testDemo() {
		let demo = Demo.swiftUI

		DemoList.Workflow.Action
            .tester(withState: DemoList.Workflow().makeInitialState())
			.send(action: .demo(demo))
			.assert(output: demo)
	}

	func testRenderingScreen() throws {
		let swiftUIDemo = Demo.swiftUI
		let uiKitDemo = Demo.uiKit(declarative: false)
		let declarativeUIKitDemo = Demo.uiKit(declarative: true)
		let demos = [swiftUIDemo, uiKitDemo, declarativeUIKitDemo]

		try DemoList.Workflow()
			.renderTester()
			.expectWorkflow(
				type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
				producingRendering: ()
			)
			.render { item in
				let alertScreen = try XCTUnwrap(item.screen.wrappedScreen as? Alert.Screen<DemoList.Screen>)
				let screen = alertScreen.baseScreen
				XCTAssertEqual(screen.demos, demos)
			}
	}

	func testRenderingBarContent() throws {
		try DemoList.Workflow()
			.renderTester()
			.expectWorkflow(
				type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
				producingRendering: ()
			)
			.render { item in
				let barContent = try XCTUnwrap(item.barVisibility[expecting: Bar.Content.self])
				XCTAssertEqual(barContent.title, "Workflow Demo")
			}
	}

	func testRenderingSelectDemo() throws {
		let demo = Demo.swiftUI

		try DemoList.Workflow()
			.renderTester()
			.expectWorkflow(
				type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
				producingRendering: ()
			)
			.render { backStackScreen in
				let wrappedScreen = backStackScreen.screen.wrappedScreen
				let alertScreen = try XCTUnwrap(wrappedScreen as? Alert.Screen<DemoList.Screen>)
				let demoListScreen = alertScreen.baseScreen
				demoListScreen.selectDemo(demo)
			}
			.assert(action: DemoList.Workflow.Action.demo(demo))
	}
}

// MARK: -
extension Bar.Visibility: CaseAccessible {}
