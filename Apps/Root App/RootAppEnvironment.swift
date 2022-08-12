// Copyright © Fleuronic LLC. All rights reserved.

import enum Root.Root
import class Foundation.ProcessInfo

extension Root.App {
	@propertyWrapper
	struct Environment {
		private let key: Key

		init(_ key: Key) {
			self.key = key
		}

		var wrappedValue: String? {
			ProcessInfo.processInfo.environment[key.rawValue]
		}
	}
}

// MARK: -
extension Root.App.Environment {
	enum Key: String {
		case apiKey
	}
}
