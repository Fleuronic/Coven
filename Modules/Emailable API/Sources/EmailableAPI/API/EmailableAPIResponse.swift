// Copyright © Fleuronic LLC. All rights reserved.

import protocol Emissary.APIResponse

public extension Emailable.API {
	struct Response {
		private let container: SingleValueDecodingContainer
	}
}

// MARK: -
extension Emailable.API.Response: APIResponse {
	public func resource<Resource: Decodable>() throws -> Resource {
		try container.decode(Resource.self)
	}

	// MARK: Decodable
	public init(from decoder: Decoder) throws {
		container = try decoder.singleValueContainer()
	}
}
