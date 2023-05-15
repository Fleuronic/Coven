// Copyright © Fleuronic LLC. All rights reserved.

import UIKit

import enum Assets.Colors
import struct Metric.Styled

public extension UIButton {
	enum Style {
		case primary
	}

	static func style(_ style: Style) -> Styled<UIButton> {
		.init()
			.style(style)
	}
}

// MARK: -
private extension Styled where Base: UIButton {
	func style(_ style: UIButton.Style) -> Self{
		switch style {
		case .primary:
			return self
				.titleColor { $0.light }
				.backgroundColor(darkenedBy: .highlighted, fadedTo: .disabled) { $0.primary }
				.cornerRadius { $0.button }
		}
	}
}
