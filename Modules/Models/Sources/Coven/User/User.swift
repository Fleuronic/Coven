// Copyright © Fleuronic LLC. All rights reserved.

import SwiftPhoneNumberFormatter

public struct User {
	public var username: Username

	public init(
		username: Username
	) {
		self.username = username
	}
}

// MARK: -
extension User: Equatable {}

extension User: Hashable {}
