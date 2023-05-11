// Copyright © Fleuronic LLC. All rights reserved.

import RegexBuilder

public extension User {
	struct Username: Equatable {
		public let rawValue: String

		public init(text: String) {
			rawValue = text.replacing(Self.regex, with: \.output.1)
		}
	}
}

// MARK: -
public extension User.Username {
	var isValid: Bool {
		!rawValue.isEmpty
	}

	var displayValue: String {
		rawValue.isEmpty ? .init() : .prefix + rawValue
	}

	static var empty: Self {
		.init(text: .init())
	}

	static var maxLength: Int {
		return String.prefix.count + .maxUsernameLength
	}

	static var validCharacter: Regex<Substring> {
		.init { CharacterClass.valid }
	}
}

// MARK: -
extension User.Username: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		rawValue = try container.decode(String.self)
	}
}

extension User.Username: Hashable {}

// MARK: -
private extension User.Username {
	static var regex: Regex<(Substring, Substring)> {
		.init {
			CharacterClass.prefix
			Capture { ZeroOrMore { CharacterClass.valid } }
		}
	}
}

// MARK: -
private extension Int {
	static let maxUsernameLength = 16
}

// MARK: -
private extension String {
	static let prefix = "@"
	static let underscore = "_"
}

// MARK: -
private extension CharacterClass {
	static let prefix = Self.anyOf(String.prefix)
	static let uppercaseLetter = "A"..."Z"
	static let lowercaseLetter = "a"..."z"
	static let underscore = Self.anyOf(String.underscore)
	static let valid = Self(.uppercaseLetter, .lowercaseLetter, .digit, .underscore)
}
