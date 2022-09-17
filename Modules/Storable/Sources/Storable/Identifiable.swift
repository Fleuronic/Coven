// Copyright © Fleuronic LLC. All rights reserved.

import struct Foundation.UUID
import class Stores.MultiFileSystemStore

public extension Storable where Self: Identifiable {
	static func stored(id: ID) -> Self? {
		store.object(withId: id)
	}

	// MARK: Storable
	func store() -> Self {
		try! Self.store.save(self)
		return self
	}

	@discardableResult
	func removeFromStorage() -> Self {
		try? Self.store.remove(withId: id)
		return self
	}

	static func removeFromStorage() {
		try? Self.store.removeAll()
	}
}

// MARK: -
private extension Storable where Self: Identifiable {
	static var store: MultiFileSystemStore<Self> {
		.init(identifier: .init(describing: self))
	}
}

// MARK: -
public extension Array where Element: Storable & Identifiable {
	static var storedCount: Int {
		store.objectsCount
	}
}

// MARK: -
extension Array: Storable where Element: Storable & Identifiable {
	// MARK: Storable
	public static var stored: Self? {
		if let elementType = Element.self as? Prestored.Type {
			return elementType
				.store
				.values
				.compactMap { $0 as? Element }
		}

		return store.allObjects()
	}

	@discardableResult
	public func store() -> Self {
		try! forEach(Self.store.save)
		return self
	}

	@discardableResult
	public func removeFromStorage() -> Self {
		try? Self.store.remove(withIds: map(\.id))
		return self
	}

	static func removeFromStorage() {
		try? store.removeAll()
	}
}

// MARK: -
private extension Array where Element: Storable & Identifiable {
	static var store: MultiFileSystemStore<Element> {
		Element.store
	}
}

// MARK: -
public extension Prestored where Self: Identifiable {
	// MARK: Prestored
	static var prestoredDictionary: [String: Self] {
		.init(
			uniqueKeysWithValues: prestoredValues.map {
				(UUID().description, $0)
			}
		)
	}

	// MARK: Storable
	static func stored(id: ID) -> Self? {
		store[key(for: id)]
	}

	@discardableResult
	func store() -> Self {
		universalStore[key] = self
		return self
	}

	@discardableResult
	func removeFromStorage() -> Self {
		universalStore.removeValue(forKey: key)
		return self
	}
}

// MARK: -
private extension Prestored where Self: Identifiable {
	var key: String {
		.init(describing: id)
	}

	static func key(for id: ID) -> String {
		.init(describing: id)
	}
}
