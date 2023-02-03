// Copyright © Fleuronic LLC. All rights reserved.

import RegexBuilder

public struct OTP {
	public let rawValue: String

	public init(text: String) {
		rawValue = text
	}
}

// MARK: -
public extension OTP {
	var isComplete: Bool {
		rawValue.count == .digitsCount
	}

	static var empty: Self {
		.init(text: .init())
	}

	static var validLength: Int {
		.digitsCount
	}

	static var validCharacter: Regex<Substring> {
		.init { CharacterClass.valid }
	}
}

// MARK: -
extension OTP: Hashable {}

extension OTP: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		rawValue = try container.decode(String.self)
	}
}

// MARK: -
private extension Int {
	static let digitsCount = 6
}

// MARK: -
private extension CharacterClass {
	static let valid = Self(.digit)
}
