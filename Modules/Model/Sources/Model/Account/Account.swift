// Copyright © Fleuronic LLC. All rights reserved.

import struct SwiftPhoneNumberFormatter.PhoneNumber

public struct Account {
	public let phoneNumber: PhoneNumber

	public init(
		phoneNumber: PhoneNumber
	) {
		self.phoneNumber = phoneNumber
	}
}
