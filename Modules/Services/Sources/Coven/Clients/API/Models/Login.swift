// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.Account
import struct Coven.User

public struct Login {
	public let account: Account
	public let user: User

	public init(
		account: Account,
		user: User
	) {
		self.account = account
		self.user = user
	}
}
