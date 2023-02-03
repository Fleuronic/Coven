// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Geometric
import Elements
import Layoutless
import Ergo

public extension Authentication.Credentials {
	final class View: UIView {}
}

// MARK: -
extension Authentication.Credentials.View: Stacking {
	public typealias Screen = Authentication.Credentials.Screen

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
			UITextField.style(.phoneNumber)
				.text(screen.phoneNumberDisplayValue)
				.hasError(screen.hasInvalidPhoneNumber)
				.placeholder(screen.phoneNumberPlaceholder)
				.isFocused(screen.needsPhoneNumberReinput)
				.edited(screen.phoneNumberTextEdited)
				.height { $0.element }
			UIButton.style(.primary)
				.title(screen.submitTitle)
				.isEnabled(screen.canSubmit)
				.showsActivity(screen.isVerifyingCredentials)
				.tap(screen.submitTapped)
				.height { $0.element }
		}.horizontalInsets { $0.element }.centeringVerticallyInParent()
		UIView.spacer
	}
}

// MARK: -
extension Authentication.Credentials.Screen: ReactiveScreen {
	public typealias View = Authentication.Credentials.View
}
