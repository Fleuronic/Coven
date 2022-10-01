// Copyright © Fleuronic LLC. All rights reserved.

import class Stores.SingleFileSystemStore

public protocol Storable: Codable {
	static var stored: Self? { get }

	func store() -> Self
	func removeFromStorage() -> Self
}

// MARK: -
public extension Storable {
	static var stored: Self? {
		return store?.object()
	}

	@discardableResult
	func store() -> Self {
		try! Self.store?.save(self)
		return self
	}

	@discardableResult
	func removeFromStorage() -> Self {
		try? Self.store?.remove()
		return self
	}

	static func removeFromStorage() {
		try? store?.remove()
	}
}

// MARK: -
private extension Storable {
	static var store: SingleFileSystemStore<Self>? {
		if self is Ephemeral.Type { return nil }
		return .init(identifier: .init(describing: self))
	}
}
