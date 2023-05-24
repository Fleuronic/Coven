// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import ErgoDeclarativeUIKitTesting

@testable import enum DemoList.DemoList

final class DemoListSnapshotTests: XCTestCase {
	func testView() {
		assertView(
			ofType: DemoList.View.self,
			named: "DemoListView",
			backedBy: .init { _ in },
			matchesSnapshotIn: #filePath
		)
	}
}
