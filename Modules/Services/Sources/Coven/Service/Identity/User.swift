// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Identity
import Schemata
import PersistDB
import Catena

import struct Coven.User
import struct Coven.Account
import struct Coven.PhoneNumber

public struct IdentifiedUser: Equatable, Hashable {
	public let id: Self.ID
	public let value: User

	init(
		id: Self.ID,
		value: User
	) {
		self.id = id
		self.value = value
	}
}

// MARK: -
public extension User {
	typealias Identified = IdentifiedUser

	var identified: Identified {
		.init(
			id: .random,
			value: self
		)
	}
}

// MARK: -
extension User.Identified: Identifiable {
	public typealias RawIdentifier = UUID
}

extension User.Identified: Catena.Model {
	// MARK: Model
	public static let schema = Schema(
		Self.init ~ "users",
		idProperty,
		\.value.username ~ "username"
	)

	public var valueSet: ValueSet<Self> {
		[
			\.value.username == value.username
		]
	}
}

// MARK: -
private extension User.Identified {
	init(
		id: ID,
		username: User.Username
	) {
		self.id = id

		value = .init(username: username)
	}
}
