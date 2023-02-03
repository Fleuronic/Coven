// Copyright © Fleuronic LLC. All rights reserved.

import protocol Catenary.APIError

public extension API {
	struct Error {
		public let message: String

		public init(message: String) {
			self.message = message
		}
	}
}

// MARK: -
extension API.Error: APIError {}
