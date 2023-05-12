// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Layoutless
import Elements
import Ergo

public extension Counter {
	final class View: UIView {}
}

// MARK: -
extension Counter.View: Layoutable {
	public typealias Screen = Counter.Screen

	public func layout(with screen: some ScreenProxy<Screen>) -> AnyLayout {
		UIStackView.style(.counter) {
			UILabel.style(.counter)
				.text(screen.valueText)
			UIButton.style(.counter)
				.title(screen.incrementTitle)
				.tap(screen.increment)
				.height { $0.element }
			UIButton.style(.counter)
				.title(screen.decrementTitle)
				.tap(screen.decrement)
				.height { $0.element }
		}.margins { $0.element }.centeringInParent()
	}
}

// MARK: -
extension Counter.Screen: ReactiveScreen {
	public typealias View = Counter.View
}
