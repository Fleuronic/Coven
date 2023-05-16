// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Layoutless

import struct Metric.Styled

public extension UIStackView {
	enum Style {
		case element
	}
}

// MARK: -
public extension UIStackView {
	static func style(_ style: Style) -> Styled<UIStackView> {
		.init().style(style)
	}
}

// MARK: -
private extension Styled where Base: UIStackView {
	func style(_ style: UIStackView.Style) -> Self {
		switch style {
		case .element:
			return self
				.verticalSpacing { $0.element }
		}
	}
}

