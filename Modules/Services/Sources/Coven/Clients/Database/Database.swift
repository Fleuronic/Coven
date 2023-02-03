// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid

import struct Coven.Account
import struct Coven.User

public struct Database {
	public private(set) var store: Store<ReadWrite>

	public init() async {
		store = try! await Self.createStore()
	}
}

// MARK: -
extension Database: Catenoid.Database {
	public static var types: [AnyModel.Type] {
		[
			Account.Identified.self,
			User.Identified.self
		]
	}

	public mutating func clear() async throws {
		try Store.destroy()
		store = try await Self.createStore()
	}
}
