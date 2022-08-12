import XCTest

class TodoUITests: XCTestCase {
	override func setUpWithError() throws {
	  continueAfterFailure = false
	  app.launch()
	}

	func testViewContents() {
		let welcomeText = app.staticTexts["What do you have to do?"]
		XCTAssert(welcomeText.exists)
	}

	private let app = XCUIApplication()
}
