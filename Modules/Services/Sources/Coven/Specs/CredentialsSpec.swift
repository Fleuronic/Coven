// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import struct Model.User
import struct Model.PhoneNumber

public protocol CredentialsSpec {
	func verifyCredentials(
		username: User.Username,
		phoneNumber: PhoneNumber
	) async -> API.Credentials.Verification.Result
}
