// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import ReactiveKit
import Geometric
import Telemetric

import struct Metric.Percentage
import struct Metric.Opacity
import struct Metric.Styled
import protocol Metric.Text

public typealias SharedString = (Strings.Type) -> String

public extension Styled {
	func borderColor(color: (Colors.Border.View.Type) -> UIColor) -> Self {
		borderColorAsset(color: color)
	}
}

// MARK: -
public extension Styled where Base: UIButton {
	func titleColor(color: @escaping (Colors.Text.Type) -> UIColor) -> Self {
		titleColorAsset(color)
	}

	func backgroundColor(darkenedBy percentage: Percentage, fadedTo opacity: Opacity, color: @escaping (Colors.Background.Button.Type) -> UIColor) -> Self {
		backgroundColorAsset(darkenedBy: percentage, fadedTo: opacity, color: color)
	}
}

// MARK: -
public extension Styled where Base: UITextField {
	func backgroundColor(color: (Colors.Background.TextField.Type) -> UIColor) -> Self {
		backgroundColorAsset(color: color)
	}
}

// MARK: -
public extension Styled where Base: Text {
	func textColor(color: @escaping (Colors.Text.Type) -> UIColor) -> Self {
		textColorAsset(color)
	}

	func textColor<Source: SignalProtocol>(_ source: Source) -> Self where Source.Element == (Colors.Text.Type) -> UIColor, Source.Error == Never {
		textColorAssetFromSource(source)
	}

	func hasError<Source: SignalProtocol>(_ source: Source) -> Self where Source.Element == Bool, Source.Error == Never {
		textColor(source.map { $0 ? { $0.error } : { $0.primary } })
	}
}
