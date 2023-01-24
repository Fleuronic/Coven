// Copyright © Fleuronic LLC. All rights reserved.

import struct Foundation.UUID
import struct Model.PhoneNumber
import struct Identity.Identifier
import struct Schemata.Value
import protocol Schemata.ModelValue
import protocol Schemata.AnyModelValue

extension PhoneNumber: AnyModelValue {}

extension PhoneNumber: ModelValue {
	public static var value: Schemata.Value<String, Self> {
		String.value.bimap(
			decode: Self.init(text:),
			encode: \.rawValue
		)
	}
}
