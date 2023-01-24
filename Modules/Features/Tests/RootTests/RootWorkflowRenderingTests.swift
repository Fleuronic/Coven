import XCTest

@testable import WorkflowUI
@testable import WorkflowTesting
@testable import WorkflowContainers

@testable import enum Root.Root
@testable import enum Authentication.Authentication

class RootWorkflowRenderingTests: XCTestCase {
	func testLoggedInUser() throws {
		let name = "Jordan"
		try Root.Workflow()
			.renderTester(initialState: .authentication)
			.expectWorkflow(
				type: Authentication.Workflow.self,
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
				
				let authenticationScreen = try XCTUnwrap(items[0].screen.wrappedScreen as? Authentication.Screen)
				XCTAssertEqual(authenticationScreen.name, name)
			}
			.assert(state: .todo(name: name))
	}
}
