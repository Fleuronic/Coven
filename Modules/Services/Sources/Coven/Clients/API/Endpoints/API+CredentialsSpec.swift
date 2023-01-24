// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB
import struct Model.User
import struct Model.PhoneNumber

extension API: CredentialsSpec {
	public func verifyCredentials(
		username: User.Username,
		phoneNumber: PhoneNumber
	) async -> Credentials.Verification.Result {
		let usernames = await query(AccountUsernameFields.self, where: \.value.phoneNumber == phoneNumber).map { $0.map(\.username) }
		let phoneNumbers = await query(AccountPhoneNumberFields.self, where: \.user.value.username == username).map { $0.map(\.phoneNumber) }

		return usernames.flatMap { usernames in
			phoneNumbers.map { phoneNumbers in
				(username, phoneNumber, usernames, phoneNumbers)
			}.map(Credentials.Verification.init)
		}
	}
}
