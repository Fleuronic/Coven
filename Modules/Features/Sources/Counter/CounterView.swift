// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
import Ergo

public extension Counter {
	struct View {
		public init() {}
	}
}

// MARK: -
extension Counter.View: ScreenBacked {
	public func body(backedBy screen: Counter.Screen) -> some View {
		VStack {
			Text(screen.valueText)
			Button(action: screen.increment) {
				Text(screen.incrementTitle)
			}
			Button(action: screen.decrement) {
				Text(screen.decrementTitle)
			}
		}
	}
}

// MARK: -
extension Counter.Screen: PublishedScreen {
	public typealias View = Counter.View
}
