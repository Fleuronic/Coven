// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Identity
import Schemata

import struct Coven.PhoneNumber

extension PhoneNumber: AnyModelValue {}

extension PhoneNumber: ModelValue {
	public static var value: Schemata.Value<String, Self> {
		String.value.bimap(
			decode: Self.init(text:),
			encode: \.rawValue
		)
	}
}
