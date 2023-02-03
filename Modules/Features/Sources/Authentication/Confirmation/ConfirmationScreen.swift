// Copyright © Fleuronic LLC. All rights reserved.

import Ergo

import enum Assets.Strings
import struct Textbelt.OTP

public extension Authentication.Confirmation {
	struct Screen {
		let canInputOTP: Bool
		let otpInputState: OTP.InputState
		let otpDigitsEdited: Event<String>
	}
}

// MARK: -
extension Authentication.Confirmation.Screen {
	public typealias Strings = Assets.Strings.Authentication.Confirmation

	var header: ScreenString {
		{ $0.header }
	}

	var prompt: ScreenString {
		{ $0.prompt }
	}

	var otpRawValue: String {
		otpInputState.input.rawValue
	}

	var needsOTPInput: Bool {
		guard canInputOTP else { return false }

		switch otpInputState.verificationState {
		case .pending(complete: false), .rejected:
			return true
		default:
			return false
		}
	}

	var hasRejectedOTP: Bool {
		otpInputState.verificationState == .rejected
	}
}
