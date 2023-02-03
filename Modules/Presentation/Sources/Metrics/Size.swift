// Copyright © Fleuronic LLC. All rights reserved.

import struct Metric.Size

public extension Size {
	static let confirmationCode = Self(width: .confirmationCode, height: .confirmationCode)
}

// MARK: -
extension Size.Width {
	static let confirmationCode: Self = 320
}

// MARK: -
public extension Size.Height {
	static let element: Self = 44
}

// MARK: -
extension Size.Height {
	static let confirmationCode: Self = 60
}
