// Copyright © Fleuronic LLC. All rights reserved.

import struct Foundation.URL
import protocol Emissary.API

public extension Emailable {
	struct API {
		let apiKey: String

		public init(apiKey: String) {
			self.apiKey = apiKey
		}
	}
}

// MARK: -
extension Emailable.API: API {
	public var baseURL: URL {
		URL(string: "https://api.emailable.com/v1/")!
	}
}
