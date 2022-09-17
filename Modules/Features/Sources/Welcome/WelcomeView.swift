// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Ergo
import Geometric
import Telemetric
import Styles
import ReactiveKit

import struct Layoutless.Layout

public extension Welcome {
	final class View: UIView {}
}

// MARK: -
extension Welcome.View: Stacking {
	public typealias Screen = Welcome.Screen

	@VerticallyStacked<Self>
	public func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView> {
		UIView.containing(
			UILabel.style(.header)
				.text(screen.prompt)
				.margins(.element)
				.centeringInParent()
		)
		UIStackView.vertical(spacing: .element) {
			UITextField.style(.name)
				.text(screen.name)
				.placeholder(screen.namePlaceholder)
				.edited(screen.nameTextEdited)
				.height(.element)
			UITextField.style(.email)
				.text(screen.email)
				.placeholder(screen.emailPlaceholder)
				.edited(screen.emailTextEdited)
				.height(.element)
			UIButton.style(.primary)
				.title(screen.loginTitle)
				.isEnabled(screen.canLogIn)
				.showsActivity(screen.isVerifyingEmail)
				.tap(screen.loginTapped)
				.height(.element)
		}.insetBy(horizontalInsets: .element).centeringVerticallyInParent()
		UIStackView.vertical(spacing: .element) {
			UILabel.style(.error)
				.isVisible(screen.hasInvalidEmail)
				.text(screen.invalidEmailErrorMessage)
			UILabel.style(.error)
				.text(screen.errorMessage)
		}.insetBy(insets: .element)
		UIView.spacer
	}
}

// MARK: -
extension Welcome.Screen: ReactiveScreen {
	public typealias View = Welcome.View
}
