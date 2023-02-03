// Copyright © Fleuronic LLC. All rights reserved.

import Foundation

import enum Authentication.Authentication

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
	}
}
