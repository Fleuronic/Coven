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

public extension Welcome {
	final class View: UIView {}
}

// MARK: -
extension Welcome.View: Stacking {
	public typealias Screen = Welcome.Screen

	@VerticallyStacked<Self>
	public func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView> {
		UIView.containing(
			UIStackView.vertical(spacing: .element) {
				UILabel.style(.header)
					.text(screen.header)
				UILabel.style(.prompt)
					.text(screen.prompt)
			}.margins(.element).centeringInParent()
		)
		UIStackView.vertical(spacing: .element) {
			UITextField.style(.username)
				.text(screen.usernameDisplayValue)
				.placeholder(screen.usernamePlaceholder)
				.edited(screen.usernameTextEdited)
				.height(.element)
			UITextField.style(.phoneNumber)
				.text(screen.phoneNumberDisplayValue)
				.placeholder(screen.phoneNumberPlaceholder)
				.edited(screen.phoneNumberTextEdited)
				.height(.element)
			UIButton.style(.primary)
				.title(screen.submitTitle)
				.isEnabled(screen.canSubmit)
				.tap(screen.submitTapped)
				.height(.element)
		}.insetBy(horizontalInsets: .element).centeringVerticallyInParent()
		UIView.spacer
	}
}

// MARK: -
extension Welcome.Screen: ReactiveScreen {
	public typealias View = Welcome.View
}
