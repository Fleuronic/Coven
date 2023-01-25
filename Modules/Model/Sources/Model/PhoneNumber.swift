// Copyright © Fleuronic LLC. All rights reserved.

import RegexBuilder
import struct SwiftPhoneNumberFormatter.PhoneNumber

public struct PhoneNumber {
	public let rawValue: String

	public init(text: String) {
		rawValue = text.digits
	}
}

// MARK: -
extension PhoneNumber: Hashable {}

extension PhoneNumber: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		rawValue = try container.decode(String.self)
	}
}

extension PhoneNumber: ExpressibleByStringLiteral {
	public init(stringLiteral: StringLiteralType) {
		rawValue = stringLiteral.digits
	}
}

// MARK: -
public extension PhoneNumber {
	var isValid: Bool {
		rawValue.count == .phoneNumberLength
	}

	var displayValue: String {
		let phoneNumber = SwiftPhoneNumberFormatter.PhoneNumber(countryCode: .usAndCanada, digits: rawValue)
		return Self.formatter.formattedNumber(phoneNumber)!
	}

	static var empty: Self {
		.init(text: .init())
	}

	static var validLength: Int {
		.formattedPhoneNumberLength
	}

	static var validCharacter: Regex<Substring> {
		.init { CharacterClass.valid }
	}
}

// MARK: -
private extension PhoneNumber {
	static let formatter = SwiftPhoneNumberFormatter.PhoneNumber.Formatter()
}

// MARK: -
private extension Int {
	static let phoneNumberLength = 10
	static let formattedPhoneNumberLength = 14
}

// MARK: -
private extension CharacterClass {
	static let valid = Self(.digit)
}
