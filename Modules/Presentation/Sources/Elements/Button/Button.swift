// Copyright © Fleuronic LLC. All rights reserved.

import UIKit

import struct Metric.Styled

public extension UIButton {
	enum Style {
		case primary
		case counter
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
		case .counter:
			return self
				.titleColor { $0.primary }
		}
	}
}
