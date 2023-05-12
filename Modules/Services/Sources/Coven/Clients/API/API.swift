// Copyright © Fleuronic LLC. All rights reserved.

import Foundation

import protocol Caesura.HasuraAPI
import protocol Catenary.APIError

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
		URL(string: "https://modo.hasura.app/v1/graphql")!
	}
}
