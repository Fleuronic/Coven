// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Geometric
import Layoutless

import struct Metric.Styled

public extension UIStackView {
	enum Style {
		case element
		case outline
		case counter
	}
}

// MARK: -
public extension UIStackView {
	static func style(_ style: Style, @LayoutBuilder content: () -> [AnyLayout]) -> Layout<UIStackView> {
		self
			.style(style)
			.content(content())
	}

	static func style(_ style: Style, arranging views: [Styled<UIView>]) -> Layout<UIStackView> {
		self
			.style(style)
			.content(views.map(\.layout))
	}
}

// MARK: -
private extension UIStackView {
	static func style(_ style: Style) -> Styled<UIStackView> {
		.init()
			.style(style)
	}
}

// MARK: -
private extension Styled where Base: UIStackView {
	func style(_ style: UIStackView.Style) -> Self {
		switch style {
		case .element:
			return self
				.axis(.vertical)
				.verticalSpacing { $0.element }
		case .outline:
			return self
				.distribution(.fillEqually)
				.horizontalInsets { $0.outline }
				.horizontalSpacing { $0.outline }
		case .counter:
			return self
				.axis(.vertical)
				.alignment(.center)
		}
	}
}

