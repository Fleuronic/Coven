// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB

import enum Catenary.Request
import struct Coven.Account
import struct Coven.User
import struct Coven.Credentials
import struct CovenService.AccountUsernameFields
import struct CovenService.AccountPasswordFields
import protocol CovenService.LoginSpec

extension API: LoginSpec {
	public func logIn(_ account: Account, for user: User) async -> Login.Result {
		await fetch(Account.Identified.self, where: \.value.password == account.password).flatMap { ids in
			if let id = ids.first {
				return .success(id)
			} else {
				return await insert(user.identified).flatMap { userID in
					return await insert(account.identified(for: user, with: userID))
				}
			}
		}
	}

	public func logOut(_ account: Account) async {

	}
}

// MARK: -
public extension Login {
	typealias Result = API.Result<Account.Identified.ID>
}
