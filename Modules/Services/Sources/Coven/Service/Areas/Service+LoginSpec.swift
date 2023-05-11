// Copyright © Fleuronic LLC. All rights reserved.

import Identity
import Catenary

import struct Coven.Credentials
import struct Coven.Account
import struct Coven.User
import struct Coven.PhoneNumber

extension Service: LoginSpec where
	API: LoginSpec,
	API.LoginResult == Result<Account.Identified.ID, Request.Error<GraphQL.Error.List>>,
	Database: LoginSpec,
	Database.LoginResult == Account.Identified.ID {
	public func logIn(_ account: Account, for user: User) async -> API.LoginResult {
		await api.logIn(account, for: user).map { _ in
			await database.logIn(account, for: user)
		}
	}

	public func logOut(_ account: Account) async {
		await api.logOut(account)
	}
}
