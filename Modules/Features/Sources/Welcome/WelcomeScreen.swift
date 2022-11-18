// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings
import typealias Ergo.Event

public extension Welcome {
	struct Screen {
		let username: String
		let email: String
		let password: String
		let isVerifyingEmail: Bool
		let hasInvalidEmail: Bool
 		let errorMessage: String?
		let usernameTextEdited: Event<String>
		let emailTextEdited: Event<String>
		let passwordTextEdited: Event<String>
		let signupTapped: Event<Void>
	}
}

// MARK: -
extension Welcome.Screen {
	public typealias Strings = Assets.Strings.Welcome

	var header: ScreenString {
		{ $0.header }
	}

	var prompt: ScreenString {
		{ $0.prompt }
	}

	var usernamePlaceholder: ScreenString {
		{ $0.Placeholder.username }
	}

	var emailPlaceholder: ScreenString {
		{ $0.Placeholder.email }
	}

	var passwordPlaceholder: ScreenString {
		{ $0.Placeholder.password }
	}

	var signupTitle: ScreenString {
		{ $0.Title.signup }
	}

	var footer: ScreenString {
		{ $0.footer }
	}

	var invalidEmailErrorMessage: ScreenString {
		{ $0.Error.email }
	}

	var canSignUp: Bool {
		!username.isEmpty && !email.isEmpty && !password.isEmpty && !isVerifyingEmail && !hasInvalidEmail
	}
}
