// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import struct Model.User
import struct Model.Account
import struct Foundation.UUID
import struct Identity.Identifier
import struct Model.User
import struct Model.PhoneNumber
import protocol Catena.Model
import protocol Catena.Valued
import protocol Identity.Identifiable

public struct IdentifiedUser {
	public let id: Self.ID
	public let value: User

	public init(
		id: ID = .init(rawValue: .init()),
		value: User
	) {
		self.id = id
		self.value = value
	}
}

// MARK: -
public extension User {
	typealias Identified = IdentifiedUser
}

// MARK: -
extension User.Identified: Identifiable {
	public typealias RawIdentifier = UUID
}

extension User.Identified: Valued {
	// MARK: Valued
	public var valueSet: ValueSet<Self> {
		[
			\.value.username == value.username
		]
	}
}

extension User.Identified: Catena.Model {
	// MARK: Model
	public static let schema = Schema(
		Self.init ~ "users",
		idProperty,
		\.value.username ~ "username"
	)
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
