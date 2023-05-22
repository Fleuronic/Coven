// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

final class RootUITests: XCTestCase {
	private let app = XCUIApplication()

	override func setUpWithError() throws {
		continueAfterFailure = false
		app.launch()
	}

	func testTitle() {
		let titleText = app.staticTexts["Workflow Demo"]
		XCTAssert(titleText.exists)
	}

	func testSwiftUIDemo() {
		let swiftUI = app.staticTexts["SwiftUI"]
		swiftUI.tap()
		demo()
	}

	func testUIKitDemo() {
		let uiKit = app.staticTexts["UIKit"]
		uiKit.tap()
		demo()
	}

	func testDeclarativeUIKitDemo() {
		let declarativeUIKit = app.staticTexts["Declarative UIKit"]
		declarativeUIKit.tap()
		demo()
	}
}

// MARK: -
private extension RootUITests {
	func demo() {
		let valueZero = app.staticTexts["The value is 0"]
		XCTAssert(valueZero.exists)

		let incrementButton = app.buttons["+"]
		incrementButton.tap()

		let valueOne = app.staticTexts["The value is 1"]
		XCTAssert(valueOne.exists)

		let resetButton = app.buttons["Reset"]
		resetButton.tap()
		XCTAssert(valueZero.exists)

		let decrementButton = app.buttons["-"]
		decrementButton.tap()

		let valueNegativeOne = app.staticTexts["The value is -1"]
		XCTAssert(valueNegativeOne.exists)
	}
}
