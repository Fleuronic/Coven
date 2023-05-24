// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import SwiftUI
import Introspect
import ViewInspector

import enum Demo.Demo

@testable import enum DemoList.DemoList

final class DemoListViewTests: XCTestCase {
	func testView() throws {
		let swiftUIDemoExpectation = expectation(description: "swiftUIDemo")
		let uiKitDemoExpectation = expectation(description: "uiKitDemo")
		let declarativeUIKitDemoExpectation = expectation(description: "declarativeUIKit")
		let screen = DemoList.Screen { demo in
			switch demo {
			case .swiftUI:
				swiftUIDemoExpectation.fulfill()
			case .uiKit(declarative: false):
				uiKitDemoExpectation.fulfill()
			case .uiKit(declarative: true):
				declarativeUIKitDemoExpectation.fulfill()
			}
		}

		let body = DemoList.View().body(with: screen)
		let list = try body.inspect().list().forEach(0)

		for (index, demo) in screen.demos.enumerated() {
			let row = list[index]
			try XCTAssertEqual(row.text().string(), demo.name)
			screen.selectDemo(demo)
		}
		wait(for: [swiftUIDemoExpectation, uiKitDemoExpectation, declarativeUIKitDemoExpectation])
	}
}
