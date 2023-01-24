import XCTest

class TodoUITests: XCTestCase {
	override func setUpWithError() throws {
	  continueAfterFailure = false
	  app.launch()
	}

	func testViewContents() {
		let authenticationText = app.staticTexts["What do you have to do?"]
		XCTAssert(authenticationText.exists)
	}

	private let app = XCUIApplication()
}
