// Copyright © Fleuronic LLC. All rights reserved.

public struct User: Equatable, Hashable {
	public var username: Username

	public init(
		username: Username
	) {
		self.username = username
	}
}
