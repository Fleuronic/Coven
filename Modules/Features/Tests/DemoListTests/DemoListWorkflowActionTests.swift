// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import WorkflowTesting

import enum Demo.Demo

@testable import DemoList

final class DemoListWorkflowActionTests: XCTestCase {
	func testDemo() {
		let demo = Demo.swiftUI

		DemoList.Workflow.Action
			.tester(withState: ())
			.send(action: .demo(demo))
			.assert(output: demo)
	}
}
