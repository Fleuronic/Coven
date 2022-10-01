// Copyright © Fleuronic LLC. All rights reserved.

import enum Todo.Todo
import class Foundation.ProcessInfo

extension Todo.App {
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
extension Todo.App.Environment {
	enum Key: String {
		case name
		case initialTodosConfiguration
	}
}

