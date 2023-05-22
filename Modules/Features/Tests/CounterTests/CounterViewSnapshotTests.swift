// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import SnapshotTesting
import Layoutless

@testable import ErgoDeclarativeUIKit
@testable import enum Counter.Counter

final class CounterViewSnapshotTests: XCTestCase {
	func testSwiftUIView() {
		let screen = Counter.SwiftUI.Screen(
			screen: .init(
				value: 0,
				increment: {},
				decrement: {}
			)
		)

		let body = Counter.SwiftUI.View()
			.body(with: screen)
			.fixedSize()

		XCTAssertNil(
			verifySnapshot(
				matching: body,
				as: .image,
				snapshotDirectory: #filePath
					.components(separatedBy: ".")
					.dropLast(1)
					.joined(separator: ".")
					.replacing("/Tests", with: "/Resources")
			)
		)
	}

	func testUIKitView() {
		let screen = Counter.UIKit.Screen(
			screen: .init(
				value: 0,
				increment: {},
				decrement: {}
			)
		)

		let view = Counter.UIKit.View(screen: screen)
		view.update(with: screen)
		view.frame.size = .init(width: 400, height: 400)

		XCTAssertNil(
			verifySnapshot(
				matching: view,
				as: .image,
				snapshotDirectory: #filePath
					.components(separatedBy: ".")
					.dropLast(1)
					.joined(separator: ".")
					.replacing("/Tests", with: "/Resources")
			)
		)
	}

	func testDeclarativeUIKitView() {
		let screen = Counter.DeclarativeUIKit.Screen(
			screen: .init(
				value: 0,
				increment: {},
				decrement: {}
			)
		)

		let viewController = LayoutViewController<Counter.DeclarativeUIKit.View>(
			screen: screen,
			environment: .empty
		)

		XCTAssertNil(
			verifySnapshot(
				matching: viewController.view,
				as: .image,
				snapshotDirectory: #filePath
					.components(separatedBy: ".")
					.dropLast(1)
					.joined(separator: ".")
					.replacing("/Tests", with: "/Resources")
			)
		)
	}
}
