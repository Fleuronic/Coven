// Copyright © Fleuronic LLC. All rights reserved.

import enum Emissary.Request

public extension Emailable.Email {
	struct Verification {
		public let email: String
		public let reason: Reason

		public init(
			email: String,
			reason: Reason
		) {
			self.email = email
			self.reason = reason
		}
	}
}

// MARK: -
public extension Emailable.Email.Verification {
	typealias Result = Swift.Result<Self, Error>
	typealias State = Request.State<Self, Error>
	typealias Error = Request.Error<Emailable.API.Error>
}

// MARK: -
extension Emailable.Email.Verification: Decodable {}
