// Copyright © Fleuronic LLC. All rights reserved.

import Identity
import Catenary

import struct Coven.Account
import struct Coven.User

extension Service: AuthenticationSpec where
	API: AuthenticationSpec,
	API.Result == Result<Account.Identified.ID, Request.Error<GraphQL.Error.List>>,
	Database: AuthenticationSpec,
	Database.Result == Account.Identified.ID {
	public func authenticate(_ account: Account, for user: User) async -> API.Result {
		await api.authenticate(account, for: user).map { _ in
			await database.authenticate(account, for: user)
		}
	}

	public func deauthenticate(_ account: Account) async {

	}
}
