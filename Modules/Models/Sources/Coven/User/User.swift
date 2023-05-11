// Copyright © Fleuronic LLC. All rights reserved.

import SwiftPhoneNumberFormatter

public struct User: Equatable, Hashable {
	public var username: Username

	public init(
		username: Username
	) {
		self.username = username
	}
}
