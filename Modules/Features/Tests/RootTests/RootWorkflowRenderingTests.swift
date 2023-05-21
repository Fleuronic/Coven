// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import WorkflowTesting

import enum Root.Root
import struct WorkflowUI.AnyScreen

@testable import WorkflowContainers

final class RootWorkflowRenderingTests: XCTestCase {
	func testRenderingScreen() throws {
		Root.Workflow()
			.renderTester()
			.render { screen in
				XCTAssertNotEqual(screen.items.count, 0)
			}
	}
//
//	func testRenderingShowCounterDemo() throws {
//		Root.Workflow()
//			.renderTester()
//			.render { screen in
//				XCTAssertNotEqual(screen.items.count, 0)
//			}
//	}
}
