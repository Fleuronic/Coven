// Copyright © Fleuronic LLC. All rights reserved.

import Identity
import Schemata

import struct Coven.Account

public struct AccountPasswordFields {
	public let id: Account.Identified.ID
	public let password: String
}

// MARK: -
extension AccountPasswordFields: AccountFields {
	// MARK: ModelProjection
	public static let projection = Projection<Account.Identified, Self>(
		Self.init,
		Account.Identified.idKeyPath,
		\.value.password
	)
}
