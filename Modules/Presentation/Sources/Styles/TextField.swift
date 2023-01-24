// Copyright © Fleuronic LLC. All rights reserved.

import class UIKit.UITextField
import class Telemetric.TextField
import struct Telemetric.Styled
import struct Model.User
import struct Model.PhoneNumber
import struct ReactiveKit.SafeSignal

public extension UITextField {
	struct Style {
		let input: Input
		let hasError: SafeSignal<Bool>

		public init(
			input: Input,
			hasError: SafeSignal<Bool>
		) {
			self.input = input
			self.hasError = hasError
		}
	}
}

// MARK: -
public extension UITextField {
	static func style(_ style: Style) -> Styled<TextField> {
		switch style.input {
		case .username:
			return .init()
				.autocorrectionType(.no)
				.autocapitalizationType(.none)
				.maxLength(User.Username.maxLength)
				.acceptedCharacter(User.Username.validCharacter)
				.textColor(style.hasError.map { $0 ? { $0.error } : { $0.primary } })
				.backgroundColor { $0.TextField.info }
				.borderStyle(.roundedRect)
		case .phoneNumber:
			return .init()
				.keyboardType(.phonePad)
				.autocorrectionType(.no)
				.autocapitalizationType(.none)
				.maxLength(PhoneNumber.validLength)
				.acceptedCharacter(PhoneNumber.validCharacter)
				.textColor(style.hasError.map { $0 ? { $0.error } : { $0.primary } })
				.backgroundColor { $0.TextField.info }
				.borderStyle(.roundedRect)
		}
	}
}

// MARK: -
public extension UITextField.Style {
	enum Input {
		case username
		case phoneNumber
	}
}
