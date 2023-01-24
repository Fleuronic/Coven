// Copyright © Fleuronic LLC. All rights reserved.

import enum Styles.UI
import enum Geometric.UI
import class UIKit.UIView
import class UIKit.UILabel
import class UIKit.UIButton
import class UIKit.UIStackView
import class UIKit.UITextField
import struct Layoutless.Layout
import struct Ergo.VerticallyStacked
import protocol Ergo.Stacking
import protocol Ergo.ScreenProxy
import protocol Ergo.ReactiveScreen

public extension Authentication.PIN {
	final class View: UIView {}
}

// MARK: -
extension Authentication.PIN.View: Stacking {
	public typealias Screen = Authentication.PIN.Screen

	@VerticallyStacked<Self>
	public func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView> {
		UIView.spacer
	}
}

// MARK: -
extension Authentication.PIN.Screen: ReactiveScreen {
	public typealias View = Authentication.PIN.View
}
