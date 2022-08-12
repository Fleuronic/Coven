import XCTest

@testable import WorkflowUI
@testable import WorkflowTesting
@testable import BackStackContainer

@testable import enum Root.Root
@testable import enum Welcome.Welcome

class RootWorkflowRenderingTests: XCTestCase {
	func testLoggedInUser() throws {
		let name = "Jordan"
		try Root.Workflow()
			.renderTester(initialState: .welcome)
			.expectWorkflow(
				type: Welcome.Workflow.self,
				producingRendering: .init(
					name: name,
					nameTextEdited: { _ in },
					loginTapped: {}
				),
				producingOutput: .user(name: name)
			)
			.render { rendering in
				let items = rendering.items
				XCTAssertEqual(items.count, 1)
				
				let welcomeScreen = try XCTUnwrap(items[0].screen.wrappedScreen as? Welcome.Screen)
				XCTAssertEqual(welcomeScreen.name, name)
			}
			.assert(state: .todo(name: name))
	}
}
