// Copyright © Fleuronic LLC. All rights reserved.

public protocol Prestored: Storable {
	static var prestored: Self? { get }
	static var prestoredValues: [Self] { get }
	static var prestoredDictionary: [String: Self] { get }
}

// MARK: -
public extension Prestored {
	static var prestored: Self? { nil }
	static var prestoredValues: [Self] { [] }

	static var prestoredDictionary: [String: Self] {
		if let value = prestored {
			return [.init(describing: self): value]
		}
		return [:]
	}

	static func prestore() {
		universalStore.merge(prestoredDictionary, uniquingKeysWith: { (_, prestored) in prestored })
	}

	// MARK: Storable
	static var stored: Self? {
		store.values.first
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

	static func removeFromStorage() {
		for (key, value) in universalStore {
			if value is Self {
				universalStore.removeValue(forKey: key)
			}
		}
	}
}

// MARK: -
extension Prestored {
	static var store: [String: Self] {
		universalStore.compactMapValues { $0 as? Self }
	}
}

// MARK: -
private extension Prestored {
	var key: String {
		.init(describing: Self.self)
	}
}

// MARK: -
extension Array where Element: Prestored {
	static var stored: Self? {
		.init(Element.store.values)
	}

	static var storedCount: Int {
		stored!.count
	}

	static func removeFromStorage() {
		for (key, value) in universalStore {
			if value is Element {
				universalStore.removeValue(forKey: key)
			}
		}
	}
}

var universalStore: [String: Prestored] = [:]
