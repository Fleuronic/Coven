// Copyright © Fleuronic LLC. All rights reserved.

import Identity
import Catenary

import struct Coven.Account
import struct Coven.User
import struct Coven.PhoneNumber

extension Service: AuthenticationSpec where
	API: AuthenticationSpec,
	API.AuthenticationResult == Result<Account.Identified.ID, Request.Error<GraphQL.Error.List>>,
	Database: AuthenticationSpec,
	Database.AuthenticationResult == Account.Identified.ID {
	public func authenticate(_ account: Account, for user: User) async -> API.AuthenticationResult {
		await api.authenticate(account, for: user).map { _ in
			await database.authenticate(account, for: user)
		}
	}

	public func verify(username: User.Username, phoneNumber: PhoneNumber) async -> API.VerificationResult {
		await api.verify(username: username, phoneNumber: phoneNumber)
	}


	public func deauthenticate(_ account: Account) async {
		await api.deauthenticate(account)
	}
}
