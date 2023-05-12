// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.User
import struct Coven.Credentials

public extension Credentials {
	enum Verification {
		case match
		case creation
		case mismatch(Mismatch)
	}
}

// MARK: -
extension Credentials.Verification {
	init(
		username: User.Username,
		password: String,
		existingUsernames: [User.Username],
		existingPasswords: [String]
	) {
		let usernameMatches = existingUsernames.contains(username)
		let passwordMatches = existingPasswords.contains(password)
		if usernameMatches && passwordMatches {
			self = .match
		} else if existingUsernames.isEmpty && existingPasswords.isEmpty {
			self = .creation
		} else if existingPasswords.isEmpty {
			self = .mismatch(.username)
		} else {
			self = .mismatch(.password)
		}
	}
}
