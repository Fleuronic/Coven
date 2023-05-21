// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
import ErgoSwiftUI

import enum Demo.Demo

public extension DemoList {
	struct View {
		public init() {}
	}
}

// MARK: -
extension DemoList.View: BodyProvider {
	// MARK: ScreenBacked
	public typealias Screen = DemoList.Screen

	// MARK: BodyProvider
	public func body(with screen: Screen) -> some View {
		List(
			screen.demos,
			selection: .init(
				get: { nil },
				set: { $0.map(screen.selectDemo) }
			)
		) { demo in Text(demo.name) }
	}
}

// MARK: -
extension DemoList.Screen: BodyBackingScreen {
	// MARK: BodyBackingScreen
	public typealias View = DemoList.View
}
