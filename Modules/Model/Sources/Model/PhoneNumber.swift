// Copyright © Fleuronic LLC. All rights reserved.

import RegexBuilder
import struct SwiftPhoneNumberFormatter.PhoneNumber

public struct PhoneNumber {
	public let value: String

	public init(text: String) {
		value = text.digits
	}
}

// MARK: -
extension PhoneNumber: Equatable {}

extension PhoneNumber: Codable {}

// MARK: -
public extension PhoneNumber {
	var isValid: Bool {
		value.count == .phoneNumberLength
	}

	var displayValue: String {
		let phoneNumber = SwiftPhoneNumberFormatter.PhoneNumber(countryCode: .usAndCanada, digits: value)
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
