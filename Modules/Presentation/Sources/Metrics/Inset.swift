// Copyright © Fleuronic LLC. All rights reserved.

import struct Metric.Insets

public extension Insets {
	static let element: Self = 12
}

public extension Insets.Horizontal {
	static let element = Self(Insets.element)
}

public extension Insets.Vertical {
	static let element = Self(Insets.element)
}
