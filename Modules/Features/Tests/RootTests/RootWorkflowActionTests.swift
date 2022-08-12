import XCTest
import WorkflowTesting

@testable import enum Root.Root

class RootWorkflowActionTests: XCTestCase {
	func testActions() throws {
		let name = "Jordan"
		Root.Workflow.Action
			.tester(withState: .welcome)
			.send(action: .logIn(name: name))
			.assertNoOutput()
			.verifyState { state in
				XCTAssertEqual(state, .todo(name: name))
			}
			.send(action: .logOut)
			.assertNoOutput()
			.verifyState { state in
				XCTAssertEqual(state, .welcome)
			}
	}
}
