// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import struct Model.Account
import struct Foundation.UUID
import struct Identity.Identifier
import struct Model.User
import struct Model.PhoneNumber
import protocol Catena.Model
import protocol Catena.Valued
import protocol Identity.Identifiable

public struct IdentifiedAccount {
	public let id: Self.ID
	public let value: Account
	public let user: User.Identified

	public init(
		id: ID = .init(rawValue: .init()),
		value: Account,
		user: User.Identified
	) {
		self.id = id
		self.value = value
		self.user = user
	}
}

// MARK: -
public extension Account {
	typealias Identified = IdentifiedAccount
}

// MARK: -
extension Account.Identified: Identifiable {
	public typealias RawIdentifier = UUID
}

extension Account.Identified: Valued {
	// MARK: Valued
	public var valueSet: ValueSet<Self> {
		[
			\.value.phoneNumber == value.phoneNumber,
			\.user.id == user.id
		]
	}
}

extension Account.Identified: Catena.Model {
	// MARK: Model
	public static let schema = Schema(
		Self.init ~ "accounts",
		idProperty,
		\.value.phoneNumber ~ "phone_number",
		\.user ~ "user"
	)
}

// MARK: -
private extension Account.Identified {
	init(
		id: ID,
		phoneNumber: PhoneNumber,
		user: User.Identified
	) {
		self.id = id
		self.user = user

		value = .init(
			phoneNumber: phoneNumber
		)
	}
}
