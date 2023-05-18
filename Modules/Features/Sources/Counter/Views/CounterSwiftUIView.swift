// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
import ErgoSwiftUI

public extension Counter.SwiftUI {
	struct View {
		public init() {}
	}
}

// MARK: -
extension Counter.SwiftUI.View: BodyProvider {
	public func body(with screen: Counter.SwiftUI.Screen) -> some View {
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
extension Counter.SwiftUI.Screen: BodyBackingScreen {
	public typealias View = Counter.SwiftUI.View
}
