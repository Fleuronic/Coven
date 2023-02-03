// Copyright © Fleuronic LLC. All rights reserved.

import Catenary
import Textbelt

public extension OTP {
	struct Verification {
		public let hasVerifiedOTP: Bool
	}
}

// MARK: -
public extension OTP.Verification {
	typealias Result = Swift.Result<Self , Error>
	typealias State = Request.State<Self, Error>
	typealias Error = Request.Error<API.Error>
}

// MARK: -
extension OTP.Verification: Decodable {
	enum CodingKeys: String, CodingKey {
		case hasVerifiedOTP = "isValidOtp"
	}
}
