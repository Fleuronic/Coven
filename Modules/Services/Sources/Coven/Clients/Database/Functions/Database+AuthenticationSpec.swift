// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.Account
import struct Coven.User
import protocol CovenService.AuthenticationSpec

extension Database: AuthenticationSpec {
	public func authenticate(_ account: Account, for user: User) async -> Account.Identified.ID {
		let id = await insert(user.identified).value
		return await insert(account.identified(for: user, with: id)).value
	}

	public func deauthenticate(_ account: Account) async {
		
	}
}
