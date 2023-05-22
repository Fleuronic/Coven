// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

import enum Demo.Demo

@testable import enum DemoList.DemoList

class DemoListScreenTests: XCTestCase {
	func testScreen() {
		let demo = Demo.swiftUI
		var selectedDemo: Demo? = nil

		let screen = DemoList.Screen { selectedDemo = $0 }

		screen.selectDemo(demo)
		XCTAssertEqual(demo, selectedDemo)
	}
}
