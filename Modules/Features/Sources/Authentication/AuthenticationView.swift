// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Layoutless
import Telemetric
import Elements
import ErgoUIKit

public extension Authentication {
	final class View: UIView {}
}

// MARK: -
extension Authentication.View: Layoutable {
	public typealias Screen = Authentication.Screen

	public func layout(with screen: some ScreenProxy<Screen>) -> AnyLayout {
		return UIStackView.vertical.layout {
			UIView.containing(
				UIStackView.style(.element).layout {
					UILabel.style(.header)
						.text(screen.header)
					UILabel.style(.prompt)
						.text(screen.prompt)
				}.margins { $0.element }.centeringInParent()
			)
			UIStackView.style(.element).layout {
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
					.action(screen.submitTapped)
					.height { $0.element }
			}.horizontalInsets { $0.element }.centeringVerticallyInParent()
			UIView.spacer
		}.fillingParent()
	}
}

// MARK: -
extension Authentication.Screen: ReactiveScreen {
	public typealias View = Authentication.View
}
