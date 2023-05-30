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
		let demos = Demo.allCases

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

	func testRenderingUpdateDemos() throws {
		let workflow = DemoList.Workflow()

		try workflow
			.renderTester()
			.expectWorkflow(
				type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
				producingRendering: ()
			)
			.render { item in
				let barContent = try XCTUnwrap(item.barVisibility[expecting: Bar.Content.self])
				let rightItem = try XCTUnwrap(barContent.rightItem)
//				XCTAssertEqual(rightItem.content, .text("Update"))
			}
			.assert(action: DemoList.Workflow.Action.updateDemos)
			.assertNoOutput()

//		try workflow
//			.renderTester(
//				initialState: .init(
//					demos: Demo.allCases,
//					updateWorker: .working(to: workflow.updateDemos)
//				)
//			)
//			.expectWorkflow(
//				type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
//				producingRendering: ()
//			)
//			.render { item in
//				let barContent = try XCTUnwrap(item.barVisibility[expecting: Bar.Content.self])
//				let rightItem = try XCTUnwrap(barContent.rightItem)
//				XCTAssertFalse(rightItem.isEnabled)
//			}
//			.assert(action: DemoList.Workflow.Action.updateDemos)
//			.assertNoOutput()
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
			.assert(output: demo)
	}
}

// MARK: -
extension Bar.Visibility: CaseAccessible {}
