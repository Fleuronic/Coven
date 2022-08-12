// Copyright © Fleuronic LLC. All rights reserved.

import protocol Emissary.APIError

public extension Emailable.API {
	struct Error {
		public let message: String

		public init(message: String) {
			self.message = message
		}
	}
}

// MARK: -
extension Emailable.API.Error: APIError {}
