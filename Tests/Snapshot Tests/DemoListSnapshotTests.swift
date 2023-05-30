// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import ErgoDeclarativeUIKitTesting

import enum Demo.Demo

@testable import enum DemoList.DemoList

final class DemoListSnapshotTests: XCTestCase {
	func testView() {
		assertView(
			ofType: DemoList.View.self,
			named: "DemoListView",
			backedBy: .init(
				demos: Demo.allCases,
				selectDemo: { _ in },
				isUpdatingDemos: false
			),
			matchesSnapshotIn: #filePath
		)
	}

	func testViewLoading() {
		assertView(
			ofType: DemoList.View.self,
			named: "DemoListViewLoading",
			backedBy: .init(
				demos: Demo.allCases,
				selectDemo: { _ in },
				isUpdatingDemos: true
			),
			matchesSnapshotIn: #filePath
		)
	}
}
