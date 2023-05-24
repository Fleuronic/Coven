// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import SwiftUI
import ErgoUIKitTesting

import enum Demo.Demo

@testable import ErgoDeclarativeUIKit
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

        let viewController = LayoutViewController<DemoList.View>(
            screen: screen,
            environment: .empty
        )

        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        let view = try viewController.view.subview(0)
        let tableView = try view.tableView(0)
        tableView.frame = window.bounds

		for (index, demo) in screen.demos.enumerated() {
            let cell = tableView.cellForRow(at: .init(row: index, section: 0))
            XCTAssertEqual(cell?.textLabel?.text, demo.name)
			screen.selectDemo(demo)
		}

		wait(for: [swiftUIDemoExpectation, uiKitDemoExpectation, declarativeUIKitDemoExpectation])
	}
}
