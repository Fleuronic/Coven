// Copyright © Fleuronic LLC. All rights reserved.

import struct SwiftPhoneNumberFormatter.PhoneNumber
import protocol Coffin.Storable

public struct User {
	public let username: Username
	public let phoneNumber: PhoneNumber

	public init(
		username: Username,
		phoneNumber: PhoneNumber
	) {
		self.username = username
		self.phoneNumber = phoneNumber
	}
}

// MARK: -
extension User: Equatable {}

extension User: Codable {}

extension User: Storable {}
