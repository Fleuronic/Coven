// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Geometric
import Elements
import Layoutless
import Ergo

public extension Authentication.Confirmation {
	final class View: UIView {}
}

// MARK: -
extension Authentication.Confirmation.View: Stacking {
	public typealias Screen = Authentication.Confirmation.Screen

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
		UIStackView.style(.element, alignedBy: .center) {
			UITextField.style(.confirmationCode)
				.text(screen.otpRawValue)
				.hasError(screen.hasRejectedOTP)
				.isEnabled(screen.canInputOTP)
				.isFocused(screen.needsOTPInput)
				.edited(screen.otpDigitsEdited)
				.size { $0.confirmationCode }
		}.horizontalInsets { $0.element }.centeringVerticallyInParent()
		UIView.spacer
	}
}

// MARK: -
extension Authentication.Confirmation.Screen: ReactiveScreen {
	public typealias View = Authentication.Confirmation.View
}
