// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Geometric
import Layoutless
import Ergo

public extension Counter {
	final class View: UIView {}
}

// MARK: -
extension Counter.View: Stacking {
	public typealias Screen = Counter.Screen

	@VerticallyStacked<Self>
	public func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView> {
		UIView.spacer
	}
}

// MARK: -
extension Counter.Screen: ReactiveScreen {
	public typealias View = Counter.View
}
