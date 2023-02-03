// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.User
import struct Coven.PhoneNumber

public protocol CredentialsSpec {
	associatedtype VerificationResult

	func verifyCredentials(
		username: User.Username,
		phoneNumber: PhoneNumber
	) async -> VerificationResult
}
