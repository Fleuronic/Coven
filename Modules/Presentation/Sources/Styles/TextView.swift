// Copyright © Fleuronic LLC. All rights reserved.

import Assets
import Metrics
import class UIKit.UITextView
import struct Telemetric.Styled

public extension UITextView {
	enum Style {
		case notes
	}
}

// MARK: -
public extension UITextView {
	static func style(_ style: Style) -> Styled<UITextView> {
		switch style {
		case .notes:
			return .init()
				.borderWidth(.field)
				.borderColor { $0.TextField.secondary }
		}
	}
}

