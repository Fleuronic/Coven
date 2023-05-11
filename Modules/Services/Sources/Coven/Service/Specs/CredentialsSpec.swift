// Copyright © Fleuronic LLC. All rights reserved.

import struct Coven.Credentials

public protocol CredentialsSpec {
	associatedtype VerificationResult

	func verify(_ credentials: Credentials) async -> VerificationResult
}
