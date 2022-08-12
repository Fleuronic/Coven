import XCTest

class WelcomeUITests: XCTestCase {
	override func setUpWithError() throws {
	  continueAfterFailure = false
	  app.launch()
	}

	func testViewContents() {
		let welcomeText = app.staticTexts["Welcome! Please enter your name."]
		XCTAssert(welcomeText.exists)
	}

	private let app = XCUIApplication()
}
