// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Geometric
import Telemetric
import Layoutless
import ErgoDeclarativeUIKit

public extension Counter.DeclarativeUIKit {
	final class View: UIView {}
}

// MARK: -
extension Counter.DeclarativeUIKit.View: ReactiveView {
	public typealias Screen = Counter.DeclarativeUIKit.Screen

	public func layout(with screen: some ScreenProxy<Counter.DeclarativeUIKit.Screen>) -> AnyLayout {
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
extension Counter.DeclarativeUIKit.Screen: ReactiveScreen {
	public typealias View = Counter.DeclarativeUIKit.View
}
