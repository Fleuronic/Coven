import XCTest

class AuthenticationUITests: XCTestCase {
	override func setUpWithError() throws {
	  continueAfterFailure = false
	  app.launch()
	}

	func testViewContents() {
		let authenticationText = app.staticTexts["Authentication! Please enter your name."]
		XCTAssert(authenticationText.exists)
	}

	private let app = XCUIApplication()
}
