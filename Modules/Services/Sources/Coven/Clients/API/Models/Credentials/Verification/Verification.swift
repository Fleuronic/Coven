// Copyright © Fleuronic LLC. All rights reserved.

import Catenary

import struct Coven.User
import struct Coven.PhoneNumber
import struct Coven.Credentials

public extension Credentials {
	enum Verification {
		case match
		case creation
		case mismatch(Mismatch)
	}
}

// MARK: -
public extension Credentials.Verification {
	typealias Result = Swift.Result<Self, Error>
	typealias State = Request.State<Self, Error>
	typealias Error = Request.Error<API.Error>
}

// MARK: -
extension Credentials.Verification {
	init(
		username: User.Username,
		phoneNumber: PhoneNumber,
		existingUsernames: [User.Username],
		existingPhoneNumbers: [PhoneNumber]
	) {
		let usernameMatches = existingUsernames.contains(username)
		let phoneNumberMatches = existingPhoneNumbers.contains(phoneNumber)
		if usernameMatches && phoneNumberMatches {
			self = .match
		} else if existingUsernames.isEmpty && existingPhoneNumbers.isEmpty {
			self = .creation
		} else if existingPhoneNumbers.isEmpty {
			self = .mismatch(.username)
		} else {
			self = .mismatch(.phoneNumber)
		}
	}
}
