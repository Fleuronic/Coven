// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Textbelt

public extension OTP.Delivery {
	struct Payload {
		private let userID: User.ID
		private let phoneNumber: PhoneNumber
		private let key: String

		init(
			userID: User.ID,
			phoneNumber: PhoneNumber,
			key: String
		) {
			self.userID = userID
			self.phoneNumber = phoneNumber
			self.key = key
		}
	}
}

// MARK: -
public extension OTP.Delivery.Payload {
	var data: Data {
		"userid=\(userID.rawValue)&phone=\(phoneNumber.rawValue)&key=\(key)".data(using: .utf8)!
	}
}
