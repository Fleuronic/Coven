// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Geometric
import Layoutless
import Ergo

public extension Root.Launch {
	final class View: UIView {}
}

// MARK: -
extension Root.Launch.View: Stacking {
	public typealias Screen = Root.Launch.Screen

	@VerticallyStacked<Self>
	public func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView> {
		UIView.spacer
	}
}

// MARK: -
extension Root.Launch.Screen: ReactiveScreen {
	public typealias View = Root.Launch.View
}
