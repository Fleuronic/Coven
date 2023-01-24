// Copyright © Fleuronic LLC. All rights reserved.

import enum PersistDB.ReadWrite
import class PersistDB.Store
import struct Model.Account
import struct Model.User
import protocol Schemata.AnyModel
import protocol Catenoid.Database

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
