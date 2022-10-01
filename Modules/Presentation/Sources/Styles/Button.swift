// Copyright © Fleuronic LLC. All rights reserved.

import class UIKit.UIButton
import struct Telemetric.Styled

public extension UIButton {
	enum Style {
		case primary
	}

	static func style(_ style: Style) -> Styled<UIButton> {
		switch style {
		case .primary:
			return .init()
				.backgroundColor(darkenedBy: .highlighted, fadedTo: .disabled) { $0.primary }
				.titleColor { $0.light }
				.cornerRadius(.default)
		}
	}
}
