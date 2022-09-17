// Copyright © Fleuronic LLC. All rights reserved.

import protocol Storable.Storable

public struct User {
	public let name: String
	public let email: String

	public init(
		name: String,
		email: String
	) {
		self.name = name
		self.email = email
	}
}

// MARK: -
extension User: Equatable {}

extension User: Codable {}

extension User: Storable {}
