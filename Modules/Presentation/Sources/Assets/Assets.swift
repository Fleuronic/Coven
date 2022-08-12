// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Metric
import Telemetric

public typealias SharedString = (Strings.Type) -> String

// MARK: -
public extension Styled where Value: UIView {
	func backgroundColor(color: (Colors.Background.Type) -> UIColor) -> Self {
		backgroundColorAsset(color)
	}

	func borderColor(color: (Colors.Border.Type) -> UIColor) -> Self {
		borderColorAsset(color)
	}
}

// MARK: -
public extension Styled where Value: UIButton {
	func titleColor(color: @escaping (Colors.Text.Type) -> UIColor) -> Self {
		titleColorAsset(color)
	}

	func backgroundColor(
		darkenedBy percentage: Percentage,
		fadedTo opacity: Opacity,
		color: @escaping (Colors.Background.Button.Type) -> UIColor
	) -> Self {
		backgroundColorAsset(
			darkenedBy: percentage,
			fadedTo: opacity,
			color: color
		)
	}
}

// MARK: -
public extension Styled where Value: TextStyled {
	func textColor(color: @escaping (Colors.Text.Type) -> UIColor) -> Self {
		textColorAsset(color)
	}
}
