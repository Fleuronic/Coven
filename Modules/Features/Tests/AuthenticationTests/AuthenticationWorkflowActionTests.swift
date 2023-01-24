import XCTest
import WorkflowTesting

@testable import enum Authentication.Authentication

class AuthenticationWorkflowActionTests: XCTestCase {
	func testActions() throws {
		let name = "Jordan"
		Authentication.Workflow.Action
			.tester(withState: .init())
			.send(action: .logIn)
			.assertNoOutput()
			.verifyState { state in
				XCTAssertTrue(state.name.isEmpty)
			}
			.send(action: .updateName(name))
			.assertNoOutput()
			.verifyState { state in
				XCTAssertEqual(state.name, name)
			}
			.send(action: .logIn)
			.verifyOutput { output in
				XCTAssertEqual(output, .user(name: name))
			}
	}
}
