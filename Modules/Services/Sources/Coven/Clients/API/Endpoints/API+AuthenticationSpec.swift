// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB

import struct Coven.Account
import struct Coven.User
import struct Coven.PhoneNumber
import struct Coven.Credentials
import struct CovenService.AccountUsernameFields
import struct CovenService.AccountPhoneNumberFields
import protocol CovenService.AuthenticationSpec

extension API: AuthenticationSpec {
	public func authenticate(_ account: Account, for user: User) async -> Account.Authentication.Result {
		await fetch(Account.Identified.self, where: \.value.phoneNumber == account.phoneNumber).flatMap { ids in
			if let id = ids.first {
				return .success(id)
			} else {
				return await insert(user.identified).flatMap { userID in
					return await insert(account.identified(for: user, with: userID))
				}
			}
		}
	}

	public func verify(username: User.Username, phoneNumber: PhoneNumber) async -> Credentials.Verification.Result {
		let usernames = await fetch(\.value.phoneNumber == phoneNumber, returning: AccountUsernameFields.self).map { $0.map(\.username) }
		let phoneNumbers = await fetch(\.user.value.username == username, returning: AccountPhoneNumberFields.self).map { $0.map(\.phoneNumber) }

		return usernames.flatMap { usernames in
			phoneNumbers.map { phoneNumbers in
				(username, phoneNumber, usernames, phoneNumbers)
			}.map(Credentials.Verification.init)
		}
	}

	public func deauthenticate(_ account: Account) async {

	}
}
