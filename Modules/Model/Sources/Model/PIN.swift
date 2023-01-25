// Copyright © Fleuronic LLC. All rights reserved.

public struct PIN {
	public let rawValue: String

	public init(digits: [Int]) {
		rawValue = digits
			.map(\.description)
			.joined()
	}
}

// MARK: -
public extension PIN {
	static var empty: Self {
		.init(digits: [])
	}
}
