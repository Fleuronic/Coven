// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Metrics

import enum Assets.Colors
import struct Metric.Styled

public extension UILabel {
	enum Style {
		case header
		case prompt
		case emptyState
	}
}

// MARK: -
public extension UILabel {
	static func style(_ style: Style) -> Styled<UILabel> {
		.init()
			.font(style.font)
			.style(style)
	}
}

// MARK: -
private extension UILabel.Style {
	var font: UIFont {
		switch self {
		case .header:
			return
				.size { $0.large }
				.weight(.semibold)
				.design(.rounded)
		case .emptyState:
			return
				.size { $0.large }
				.weight(.light)
				.italic
		case .prompt:
			return
				.size { $0.small }
		}
	}
}

// MARK: -
private extension Styled where Base: UILabel {
	func style(_ style: UILabel.Style) -> Self {
		switch style {
		case .header, .prompt:
			return self
				.centered
				.multiline
		case .emptyState:
			return self
				.textColor { $0.secondary }
		}
	}
}
