// Copyright © Fleuronic LLC. All rights reserved.

public struct Credentials {
	public var username: User.Username
	public var password: String

	public init(
		username: User.Username?,
		password: String?
	) {
		self.username = username ?? .empty
		self.password = password ?? .init()
	}
}

// MARK: -
public extension Credentials {
	static var empty: Self {
		.init(
			username: nil,
			password: nil
		)
	}
}
