// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Geometric
import Layoutless
import Ergo

public extension Main {
	final class View: UIView {}
}

// MARK: -
extension Main.View: Stacking {
	public typealias Screen = Main.Screen

	@VerticallyStacked<Self>
	public func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView> {
		UIView.spacer
	}
}

// MARK: -
extension Main.Screen: ReactiveScreen {
	public typealias View = Main.View
}
