// Copyright © Fleuronic LLC. All rights reserved.

import class UIKit.UITextField
import class Telemetric.TextField
import struct Telemetric.Styled
import struct Model.User
import struct Model.PhoneNumber

public extension UITextField {
	enum Style {
		case username
		case phoneNumber
		case title
	}
}

// MARK: -
public extension UITextField {
	static func style(_ style: Style) -> Styled<TextField> {
		switch style {
		case .username:
			return .init()
				.autocorrectionType(.no)
				.autocapitalizationType(.none)
				.maxLength(User.Username.maxLength)
				.acceptedCharacter(User.Username.validCharacter)
				.backgroundColor { $0.TextField.info }
				.borderStyle(.roundedRect)
		case .phoneNumber:
			return .init()
				.keyboardType(.phonePad)
				.autocorrectionType(.no)
				.autocapitalizationType(.none)
				.maxLength(PhoneNumber.validLength)
				.acceptedCharacter(PhoneNumber.validCharacter)
				.backgroundColor { $0.TextField.info }
				.borderStyle(.roundedRect)
		case .title:
			return .init()
				.borderWidth(.field)
				.borderColor { $0.TextField.primary }
		}
	}
}
