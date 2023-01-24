// Copyright © Fleuronic LLC. All rights reserved.

import struct SwiftPhoneNumberFormatter.PhoneNumber

public struct User {
	public let username: Username

	public init(
		username: Username
	) {
		self.username = username
	}
}
