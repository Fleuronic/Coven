// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import SnapshotTesting

@testable import enum DemoList.DemoList

final class DemoListViewSnapshotTests: XCTestCase {
	func testView() {
		let body = DemoList.View()
			.body(with: .init { _ in })
			.frame(width: 200, height: 200)

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
}
