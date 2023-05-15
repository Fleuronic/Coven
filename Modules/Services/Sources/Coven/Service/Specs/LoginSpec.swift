// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.Credentials
import struct Coven.Account
import struct Coven.User

public protocol LoginSpec {
	associatedtype LoginResult

	func logIn(_ account: Account, for user: User) async -> LoginResult
	func logOut(_ account: Account) async -> LoginResult
}
