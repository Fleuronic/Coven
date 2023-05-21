// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import WorkflowTesting

import enum Demo.Demo

@testable import enum Root.Root

final class RootWorkflowActionTests: XCTestCase {
	func testShowCounterDemo() {
		let demo = Demo.swiftUI

		Root.Workflow.Action
			.tester(withState: nil)
			.send(action: .showCounterDemo(demo))
			.assert(state: demo)
			.assertNoOutput()
	}

	func testShowDemoList() {
		let demo = Demo.swiftUI

		Root.Workflow.Action
			.tester(withState: demo)
			.send(action: .showDemoList)
			.assert(state: nil)
			.assertNoOutput()
	}
}
