// Copyright © Fleuronic LLC. All rights reserved.

import protocol Catenary.APIResponse

public extension API {
	struct Response {
		private let container: SingleValueDecodingContainer
	}
}

// MARK: -
extension API.Response: APIResponse {
	public func resource<Resource: Decodable>() throws -> Resource {
		try container.decode(Resource.self)
	}

	// MARK: Decodable
	public init(from decoder: Decoder) throws {
		container = try decoder.singleValueContainer()
	}
}
