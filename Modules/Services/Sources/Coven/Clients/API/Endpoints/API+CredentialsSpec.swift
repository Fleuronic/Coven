// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB

import enum Catenary.Request
import struct Coven.Credentials
import struct CovenService.AccountUsernameFields
import struct CovenService.AccountPasswordFields
import protocol CovenService.CredentialsSpec

extension API: CredentialsSpec {
	public func verify(_ credentials: Credentials) async -> Credentials.Verification.Result {
		let username = credentials.username
		let password = credentials.password

		let usernames = await fetch(\.value.password == password, returning: AccountUsernameFields.self).map { $0.map(\.username) }
		let passwords = await fetch(\.user.value.username == username, returning: AccountPasswordFields.self).map { $0.map(\.password) }

		return usernames.flatMap { usernames in
			passwords.map { passwords in
				(username, password, usernames, passwords)
			}.map(Credentials.Verification.init)
		}
	}
}

// MARK: -
public extension Credentials.Verification {
	typealias Result = API.Result<Self>
}
