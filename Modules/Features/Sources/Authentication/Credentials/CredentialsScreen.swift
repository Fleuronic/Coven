// Copyright © Fleuronic LLC. All rights reserved.

import struct Model.User
import struct Model.PhoneNumber
import enum Assets.Strings
import typealias Ergo.Event

public extension Authentication.Credentials {
	struct Screen {
		let username: User.Username
		let phoneNumber: PhoneNumber
		let usernameTextEdited: Event<String>
		let phoneNumberTextEdited: Event<String>
		let submitTapped: Event<Void>
		let isVerifyingCredentials: Bool
		let hasInvalidUsername: Bool
		let hasInvalidPhoneNumber: Bool
	}
}

// MARK: -
extension Authentication.Credentials.Screen {
	public typealias Strings = Assets.Strings.Authentication

	var header: ScreenString {
		{ $0.header }
	}

	var prompt: ScreenString {
		{ $0.prompt }
	}

	var usernameDisplayValue: String {
		username.displayValue
	}

	var usernamePlaceholder: ScreenString {
		{ $0.Placeholder.username }
	}

	var phoneNumberDisplayValue: String {
		phoneNumber.displayValue
	}

	var phoneNumberPlaceholder: ScreenString {
		{ $0.Placeholder.phoneNumber }
	}

	var submitTitle: ScreenString {
		{ $0.Title.submit }
	}

	var canSubmit: Bool {
		username.isValid &&
		phoneNumber.isValid &&
		!hasInvalidUsername &&
		!hasInvalidPhoneNumber &&
		!isVerifyingCredentials
	}
}
