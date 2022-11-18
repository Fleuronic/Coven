// Copyright © Fleuronic LLC. All rights reserved.

import protocol Coffin.Storable

public struct User {
	public let username: String
	public let email: String
	public let password: String

	public init(
		username: String,
		email: String,
		password: String
	) {
		self.username = username
		self.email = email
		self.password = password
	}
}

// MARK: -
extension User: Equatable {}

extension User: Codable {}

extension User: Storable {}
