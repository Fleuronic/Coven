// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
import ErgoSwiftUI

public extension Root {
	struct View {
		public init() {}
	}
}

// MARK: -
extension Root.View: BodyProvider {
	// MARK: ScreenBacked
	public typealias Screen = Root.Screen

	// MARK: BodyProvider
	public func body(with screen: Screen) -> some View {
		List(
			screen.demos,
			selection: .init(
				get: { screen.selectedDemo },
				set: screen.demoSelected
			)
		) { demo in Text(demo.name) }
	}
}

// MARK: -
extension Root.Screen: BodyBackingScreen {
	// MARK: BodyBackingScreen
	public typealias View = Root.View
}
