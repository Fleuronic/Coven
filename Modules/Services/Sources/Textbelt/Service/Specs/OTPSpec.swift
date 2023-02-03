// Copyright © Fleuronic LLC. All rights reserved.

import Textbelt

public protocol OTPSpec {
	associatedtype DeliveryResult
	associatedtype VerificationResult

	func deliverOTP(toUserWith id: User.ID, at phoneNumber: PhoneNumber) async -> DeliveryResult
	func verify(_ otp: OTP, forUserWith id: User.ID) async -> VerificationResult
}
