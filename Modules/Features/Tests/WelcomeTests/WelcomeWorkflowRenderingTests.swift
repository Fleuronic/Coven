import XCTest
import WorkflowTesting

@testable import enum Welcome.Welcome

class WelcomeWorkflowRenderingTests: XCTestCase {
	func testRenderingNameTextEdited() throws {
		let name = "Jordan"
		Welcome.Workflow()
			.renderTester()
			.render { screen in
				screen.nameTextEdited(name)
			}
			.verifyState { state in
				XCTAssertEqual(state.name, name)
			}
	}

	func testRenderingLoginTapped() throws {
		let name = "Jordan"
		Welcome.Workflow()
			.renderTester()
			.render { screen in
				XCTAssertTrue(screen.name.isEmpty)
				screen.loginTapped(())
			}
			.assertNoOutput()
		Welcome.Workflow()
			.renderTester(initialState: .init(name: name))
			.render { screen in
				screen.loginTapped(())
			}
			.verifyOutput { output in
				XCTAssertEqual(output, .user(name: name))
			}
	}
}
