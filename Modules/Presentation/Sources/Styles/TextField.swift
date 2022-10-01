// Copyright © Fleuronic LLC. All rights reserved.

import class UIKit.UITextField
import struct Telemetric.Styled

public extension UITextField {
	enum Style {
		case name
		case email
		case title
	}
}

// MARK: -
public extension UITextField {
	static func style(_ style: Style) -> Styled<UITextField> {
		switch style {
		case .name:
			return .init()
				.autocorrectionType(.no)
				.autocapitalizationType(.words)
				.backgroundColor { $0.TextField.info }
				.borderStyle(.roundedRect)
		case .email:
			return .init()
				.keyboardType(.emailAddress)
				.autocorrectionType(.no)
				.autocapitalizationType(.none)
				.backgroundColor { $0.TextField.info }
				.borderStyle(.roundedRect)
		case .title:
			return .init()
				.borderWidth(.field)
				.borderColor { $0.TextField.primary }
		}
	}
}
