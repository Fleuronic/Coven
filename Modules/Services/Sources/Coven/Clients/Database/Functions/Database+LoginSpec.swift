// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.Credentials
import struct Coven.Account
import struct Coven.User
import protocol CovenService.LoginSpec

extension Database: LoginSpec {
	public func logIn(_ account: Account, for user: User) async -> Account.Identified.ID {
		let id = await insert(user.identified).value
		return await insert(account.identified(for: user, with: id)).value
	}

	public func logOut(_ account: Account) async {

	}
}
