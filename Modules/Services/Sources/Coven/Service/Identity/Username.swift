// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Identity
import Schemata

import struct Coven.User

extension User.Username: AnyModelValue {}

extension User.Username: ModelValue {
	public static var value: Schemata.Value<String, Self> {
		String.value.bimap(
			decode: Self.init(text:),
			encode: \.rawValue
		)
	}
}
