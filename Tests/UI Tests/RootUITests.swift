import XCTest

class RootUITests: XCTestCase {
	override func setUpWithError() throws {
	  continueAfterFailure = false
	  app.launch()
	}

	func testContents() {
		XCTAssert(true)
	}

	private let app = XCUIApplication()
}
