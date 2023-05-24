// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import ErgoSwiftUITesting

@testable import enum DemoList.DemoList

final class DemoListViewSnapshotTests: XCTestCase {
	func testView() {
		assertView(
			ofType: DemoList.View.self,
			named: "DemoListView",
			backedBy: .init { _ in },
			matchesSnapshotIn: #filePath
		)
	}
}

