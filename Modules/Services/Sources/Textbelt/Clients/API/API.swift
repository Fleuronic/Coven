// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Catenary

public struct API {
	let apiKey: String

	public init(apiKey: String) {
		self.apiKey = apiKey
	}
}

// MARK: -
extension API: RESTAPI {
	public var baseURL: URL {
		URL(string: "https://textbelt.com/")!
	}
}
