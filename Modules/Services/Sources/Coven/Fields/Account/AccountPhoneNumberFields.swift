// Copyright © Fleuronic LLC. All rights reserved.

import struct Model.Account
import struct Model.PhoneNumber
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
