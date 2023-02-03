// Copyright © Fleuronic LLC. All rights reserved.

import Catenary
import Textbelt

public extension OTP {
	struct Delivery {
		public let otp: OTP
	}
}

// MARK: -
public extension OTP.Delivery {
	typealias Result = Swift.Result<Self , Error>
	typealias State = Request.State<Self, Error>
	typealias Error = Request.Error<API.Error>
}

// MARK: -
extension OTP.Delivery: Decodable {}
