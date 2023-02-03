// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.Account
import struct Coven.User

public protocol AuthenticationSpec {
	associatedtype Result

	func authenticate(_ account: Account, for user: User) async -> Result
	func deauthenticate(_ account: Account) async
}
