// Copyright © Fleuronic LLC. All rights reserved.

import class UIKit.UILabel
import class UIKit.UIFont
import struct Telemetric.Styled
import protocol Metric.TextStyle
import protocol Metric.TextStyled

public enum Text {}

// MARK: -
public extension Text {
	enum Style {
		case header
		case prompt
		case footer
		case emptyState
		case error
	}
}

// MARK: -
public extension UILabel {
	static func style(_ style: Text.Style) -> Styled<UILabel> {
		let styled = Styled(UILabel()).font(style.font)

		switch style {
		case .header, .prompt:
			return styled
				.centered
				.multiline
		case .emptyState:
			return styled
				.textColor { $0.secondary }
		case .footer:
			return styled
				.centered
				.multiline
				.textColor { $0.secondary }
		case .error:
			return styled
				.centered
				.multiline
				.textColor { $0.error }
		}
	}
}

// MARK: -
extension Text.Style: TextStyle {
	public var font: UIFont {
		switch self {
		case .header:
			return
				.size(.large)
				.weight(.semibold)
				.design(.rounded)
		case .emptyState:
			return
				.size(.large)
				.weight(.light)
				.italic
		case .prompt, .footer, .error:
			return
				.size(.small)
		}
	}
}
