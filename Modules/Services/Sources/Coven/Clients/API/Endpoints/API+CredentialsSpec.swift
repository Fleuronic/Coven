// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB

import struct Coven.User
import struct Coven.PhoneNumber
import struct Coven.Credentials
import struct CovenService.AccountUsernameFields
import struct CovenService.AccountPhoneNumberFields
import protocol CovenService.CredentialsSpec

extension API: CredentialsSpec {
	public func verifyCredentials(
		username: User.Username,
		phoneNumber: PhoneNumber
	) async -> Credentials.Verification.Result {
		let usernames = await fetch(\.value.phoneNumber == phoneNumber, returning: AccountUsernameFields.self).map { $0.map(\.username) }
		let phoneNumbers = await fetch(\.user.value.username == username, returning: AccountPhoneNumberFields.self).map { $0.map(\.phoneNumber) }

		return usernames.flatMap { usernames in
			phoneNumbers.map { phoneNumbers in
				(username, phoneNumber, usernames, phoneNumbers)
			}.map(Credentials.Verification.init)
		}
	}
}
