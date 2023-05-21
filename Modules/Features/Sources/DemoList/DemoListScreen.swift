// Copyright © Fleuronic LLC. All rights reserved.

import enum Demo.Demo

public typealias DemoList = Demo.List

public extension Demo {
	enum List {}
}

// MARK: -
public extension DemoList {
	struct Screen {
		let selectDemo: (Demo) -> Void
	}
}

// MARK: -
extension DemoList.Screen {
	var demos: [Demo] {
		[
			.swiftUI,
			.uiKit(declarative: false),
			.uiKit(declarative: true)
		]
	}
}
