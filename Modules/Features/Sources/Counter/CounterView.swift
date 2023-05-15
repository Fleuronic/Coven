// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
//import UIKit

import ErgoSwiftUI

public extension Counter {
	struct View {
		public init() {}
	}
}

extension Counter.View: Bodied {
	public func body(with screen: Counter.Screen) -> some View {
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

extension Counter.Screen: PublishedScreen {
	public typealias View = Counter.View
}

/*public extension Counter {
	final class View: UIView {}
}

// MARK: -
extension Counter.View: Layoutable {
	public typealias Screen = Counter.Screen

	public func layout(with screen: some ScreenProxy<Screen>) -> AnyLayout {
		UIStackView.vertical.layout {
			UILabel.default
				.text(screen.valueText)
			UIButton.default
				.title(screen.incrementTitle)
				.action(screen.increment)
			UIButton.default
				.title(screen.decrementTitle)
				.action(screen.decrement)
		}.centeringInParent()
	}
}

// MARK: -
extension Counter.Screen: ReactiveScreen {
	public typealias View = Counter.View
}*/
