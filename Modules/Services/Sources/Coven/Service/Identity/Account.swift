// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Schemata
import PersistDB
import Identity
import Catena

import struct Coven.Account
import struct Coven.User
import struct Coven.PhoneNumber

public struct IdentifiedAccount {
	public let id: Self.ID
	public let value: Account
	public let user: User.Identified

	init(
		id: Self.ID,
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

	func identified(for user: User, with id: User.Identified.ID) -> Identified {
		.init(
			id: .random,
			value: self,
			user: .init(
				id: id,
				value: user
			)
		)
	}
}

// MARK: -
extension Account.Identified: Identifiable {
	public typealias RawIdentifier = UUID
}

extension Account.Identified: Catena.Model {
	// MARK: Model
	public static let schema = Schema(
		Self.init ~ "accounts",
		idProperty,
		\.value.phoneNumber ~ "phone_number",
		\.user ~ "user"
	)

	public var valueSet: ValueSet<Self> {
		[
			\.value.phoneNumber == value.phoneNumber,
			\.user.id == user.id
		]
	}

	public static var foreignKeys: ForeignKeys {
		[
			\.user.id: \.user
		]
	}
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
