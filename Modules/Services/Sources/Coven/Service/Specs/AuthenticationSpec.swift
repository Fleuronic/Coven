// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.Account
import struct Coven.User
import struct Coven.PhoneNumber

public protocol AuthenticationSpec {
	associatedtype AuthenticationResult
	associatedtype VerificationResult

	func authenticate(_ account: Account, for user: User) async -> AuthenticationResult
	func verify(username: User.Username, phoneNumber: PhoneNumber) async -> VerificationResult
	func deauthenticate(_ account: Account) async
}
