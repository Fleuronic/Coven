// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Metrics
import Assets
import Telemetric

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

