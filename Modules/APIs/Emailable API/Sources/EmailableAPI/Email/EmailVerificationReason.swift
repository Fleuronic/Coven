// Copyright © Fleuronic LLC. All rights reserved.

public extension Emailable.Email.Verification {
	enum Reason: String {
		case acceptedEmail = "accepted_email"
		case invalidDomain = "invalid_domain"
	}
}

// MARK: -
extension Emailable.Email.Verification.Reason: Decodable {}
