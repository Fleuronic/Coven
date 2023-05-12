// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings
import struct Coven.User
import typealias Ergo.Event

public enum Authentication {}

// MARK: -
public extension Authentication {
	struct Screen {
		let username: User.Username
		let password: String
		let usernameTextEdited: Event<String>
		let passwordEdited: Event<String>
		let submitTapped: Event<Void>
		let isAuthenticating: Bool
		let hasInvalidUsername: Bool
		let hasInvalidPassword: Bool
	}
}

// MARK: -
public extension Authentication.Screen {
	typealias Strings = Assets.Strings.Authentication
}

// MARK: -
extension Authentication.Screen {
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

	var passwordPlaceholder: ScreenString {
		{ $0.Placeholder.password }
	}

	var submitTitle: ScreenString {
		{ $0.Title.submit }
	}

	var canSubmit: Bool {
		username.isValid &&
		!password.isEmpty &&
		!hasInvalidUsername &&
		!hasInvalidPassword &&
		!isAuthenticating
	}
}
