// Copyright © Fleuronic LLC. All rights reserved.

import Textbelt
import TextbeltService

extension API: OTPSpec {
	public func deliverOTP(toUserWith id: User.ID, at phoneNumber: PhoneNumber) async -> OTP.Delivery.Result {
		let path = "otp/generate"
		let payload = OTP.Delivery.Payload(
			userID: id,
			phoneNumber: phoneNumber,
			key: apiKey
		)

		return await post(payload.data, to: path)
	}

	public func verify(_ otp: OTP, forUserWith id: User.ID) async -> OTP.Verification.Result {
		let path = "otp/verify?otp=\(otp.rawValue)&userid=\(id.rawValue)&key=\(apiKey)"
		return await getResource(at: path)
	}
}
