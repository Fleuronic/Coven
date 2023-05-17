// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
import ErgoSwiftUI

public extension Root {
	struct View {
		public init() {}
	}
}

// MARK: -
extension Root.View: ScreenBackedView {
	public func body(backedBy screen: Root.Screen) -> some View {
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
extension Root.Screen: PublishedScreen {
	public typealias View = Root.View
}
