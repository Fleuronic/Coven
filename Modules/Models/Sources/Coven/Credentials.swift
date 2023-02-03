// Copyright © Fleuronic LLC. All rights reserved.

public struct Credentials {
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
