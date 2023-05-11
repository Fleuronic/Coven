// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Layoutless
import Telemetric
import Elements
import Ergo

public extension Counter {
	final class View: UIView {}
}

// MARK: -
extension Counter.View: Layoutable {
	public typealias Screen = Counter.Screen

	public func layout(with screen: some ScreenProxy<Screen>) -> AnyLayout {
		UIStackView.style(.element) {
			UIButton.style(.primary)
				.tap(screen.increment)
				.height { $0.element }
		}.margins { $0.element }.centeringVerticallyInParent()
	}
}

// MARK: -
extension Counter.Screen: ReactiveScreen {
	public typealias View = Counter.View
}
