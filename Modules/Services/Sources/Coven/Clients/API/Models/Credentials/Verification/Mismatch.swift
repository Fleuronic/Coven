// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.Credentials

public extension Credentials.Verification {
	enum Mismatch {
		case username
		case phoneNumber
	}
}
