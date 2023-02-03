// Copyright © Fleuronic LLC. All rights reserved.

import Identity
import Schemata

import struct Coven.Account
import struct Coven.PhoneNumber
import struct Schemata.Projection

public struct AccountPhoneNumberFields {
	public let id: Account.Identified.ID
	public let phoneNumber: PhoneNumber
}

// MARK: -
extension AccountPhoneNumberFields: AccountFields {
	// MARK: ModelProjection
	public static let projection = Projection<Account.Identified, Self>(
		Self.init,
		Account.Identified.idKeyPath,
		\.value.phoneNumber
	)
}
