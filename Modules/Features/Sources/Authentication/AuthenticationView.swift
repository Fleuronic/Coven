// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Layoutless
import Elements
import Ergo

public extension Authentication {
	final class View: UIView {}
}

// MARK: -
extension Authentication.View: Stacking {
	public typealias Screen = Authentication.Screen

	@VerticallyStacked<Self>
	public func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView> {
		UIView.containing(
			UIStackView.style(.element) {
				UILabel.style(.header)
					.text(screen.header)
				UILabel.style(.prompt)
					.text(screen.prompt)
			}.margins { $0.element }.centeringInParent()
		)
		UIStackView.style(.element) {
			UITextField.style(.username)
				.text(screen.usernameDisplayValue)
				.hasError(screen.hasInvalidUsername)
				.placeholder(screen.usernamePlaceholder)
				.edited(screen.usernameTextEdited)
				.height { $0.element }
			UITextField.style(.password)
				.text(screen.password)
				.hasError(screen.hasInvalidPassword)
				.placeholder(screen.passwordPlaceholder)
				.edited(screen.passwordEdited)
				.height { $0.element }
			UIButton.style(.primary)
				.title(screen.submitTitle)
				.isEnabled(screen.canSubmit)
				.showsActivity(screen.isAuthenticating)
				.tap(screen.submitTapped)
				.height { $0.element }
		}.horizontalInsets { $0.element }.centeringVerticallyInParent()
		UIView.spacer
	}
}

// MARK: -
extension Authentication.Screen: ReactiveScreen {
	public typealias View = Authentication.View
}
