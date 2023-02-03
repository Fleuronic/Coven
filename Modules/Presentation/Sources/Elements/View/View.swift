// Copyright © Fleuronic LLC. All rights reserved.

import UIKit

import struct Metric.Styled

public extension UIView {
	enum Style {
		case cursor
	}
}

// MARK: -
public extension UIView {
	static func style(_ style: Style) -> Styled<UIView> {
		.init()
			.style(style)
	}
}

// MARK: -
private extension Styled where Base == UIView {
	func style(_ style: UIView.Style) -> Self {
		switch style {
		case .cursor:
			return self
				.cornerRadius { $0.cursor }
		}
	}
}
