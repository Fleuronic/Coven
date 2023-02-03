// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Catenary
import Caesura

public struct API {
	let apiKey: String

	public init(apiKey: String) {
		self.apiKey = apiKey
	}
}

// MARK: -
extension API: HasuraAPI {
	// MARK: API
	public var baseURL: URL {
		URL(string: "https://coven-dev.hasura.app/v1/graphql")!
	}
}
