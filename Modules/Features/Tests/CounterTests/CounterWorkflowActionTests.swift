// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import WorkflowTesting

@testable import enum Counter.Counter

final class CounterWorkflowActionTests: XCTestCase {
	func testIncrement() {
		Counter.Workflow.Action
			.tester(withState: 0)
			.send(action: .increment)
			.assert(state: 1)
			.assertNoOutput()
	}

	func testDecrement() {
		Counter.Workflow.Action
			.tester(withState: 0)
			.send(action: .decrement)
			.assert(state: -1)
			.assertNoOutput()
	}

	func testReset() {
		Counter.Workflow.Action
			.tester(withState: 0)
			.send(action: .increment)
			.send(action: .reset)
			.assert(state: 0)
			.assertNoOutput()
	}

	func testFinish() {
		Counter.Workflow.Action
			.tester(withState: 0)
			.send(action: .finish)
			.verifyOutput { XCTAssert($0 == ()) }
	}
}
