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
		fatalError()
	}

	public func logOut(_ account: Account) async -> Login.Result {
		fatalError()
	}
}

// MARK: -
public extension Login {
	typealias Result = API.Result<Account.Identified.ID>
}
