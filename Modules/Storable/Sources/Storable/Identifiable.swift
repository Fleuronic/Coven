// Copyright © Fleuronic LLC. All rights reserved.

import struct Foundation.UUID
import class Stores.MultiFileSystemStore

public extension Storable where Self: Identifiable {
	static func stored(id: ID) -> Self? {
		store?.object(withId: id)
	}

	// MARK: Storable
	func store() -> Self {
		try! Self.store?.save(self)
		return self
	}

	@discardableResult
	func removeFromStorage() -> Self {
		try? Self.store?.remove(withId: id)
		return self
	}

	static func removeFromStorage() {
		try? Self.store?.removeAll()
	}
}

// MARK: -
private extension Storable where Self: Identifiable {
	static var store: MultiFileSystemStore<Self>? {
		if self is Ephemeral.Type { return nil }
		return .init(identifier: .init(describing: self))
	}
}

// MARK: -
public extension Array where Element: Storable & Identifiable {
	static var storedCount: Int {
		store?.objectsCount ?? 0
	}
}

// MARK: -
extension Array: Storable where Element: Storable & Identifiable {
	// MARK: Storable
	public static var stored: Self? {
		store?.allObjects()
	}

	@discardableResult
	public func store() -> Self {
		forEach { try! Self.store?.save($0) }
		return self
	}

	@discardableResult
	public func removeFromStorage() -> Self {
		try? Self.store?.remove(withIds: map(\.id))
		return self
	}

	static func removeFromStorage() {
		try? store?.removeAll()
	}
}

// MARK: -
private extension Array where Element: Storable & Identifiable {
	static var store: MultiFileSystemStore<Element>? {
		Element.store
	}
}
