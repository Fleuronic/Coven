// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB

import struct Coven.Account
import struct Coven.User
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

	public func deauthenticate(_ account: Account) async {

	}
}
