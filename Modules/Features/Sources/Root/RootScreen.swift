// Copyright © Fleuronic LLC. All rights reserved.

import enum Models.Demo

public enum Root {}

// MARK: -
public extension Root {
	struct Screen {
		let selectedDemo: Demo?
		let demoSelected: (Demo?) -> Void
	}
}

// MARK: -
extension Root.Screen {
	var demos: [Demo] {
		[
			.swiftUI,
			.uiKit(declarative: false),
			.uiKit(declarative: true)
		]
	}
}
