// Copyright © Fleuronic LLC. All rights reserved.

import struct Metric.Insets

public extension Insets {
	static let element: Self = 12
}

// MARK: -
public extension Insets.Horizontal {
	static let element = Self(Insets.element)
	static let outline: Self = 20
	static let confirmationCode: Self = 26
}

// MARK: -
public extension Insets.Vertical {
	static let element = Self(Insets.element)
}
