// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Layoutless
import Ergo

public extension Root.Launch {
	final class View: UIView {}
}

// MARK: -
extension Root.Launch.View: Layoutable {
	public typealias Screen = Root.Launch.Screen

	public func layout(with screen: some ScreenProxy<Screen>) -> AnyLayout {
		EmptyLayout()
	}
}

// MARK: -
extension Root.Launch.Screen: ReactiveScreen {
	public typealias View = Root.Launch.View
}
