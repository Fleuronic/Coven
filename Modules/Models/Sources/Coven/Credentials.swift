// Copyright © Fleuronic LLC. All rights reserved.

public struct Credentials: Equatable {
	public var username: User.Username
	public var phoneNumber: PhoneNumber

	public init(
		username: User.Username?,
		phoneNumber: PhoneNumber?
	) {
		self.username = username ?? .empty
		self.phoneNumber = phoneNumber ?? .empty
	}
}

