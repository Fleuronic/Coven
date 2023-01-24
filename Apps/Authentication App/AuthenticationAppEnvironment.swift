// Copyright © Fleuronic LLC. All rights reserved.

import enum Authentication.Authentication
import class Foundation.ProcessInfo

extension Authentication.App {
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
extension Authentication.App.Environment {
	enum Key: String {
		case initialUsername
		case initialPhoneNumber
		case apiKey
		case apiConfiguration
	}
}
