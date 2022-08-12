// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings
import typealias Ergo.Event

public extension Welcome {
	struct Screen {
		let name: String
		let email: String
		let isVerifyingEmail: Bool
		let hasInvalidEmail: Bool
 		let errorMessage: String?
		let nameTextEdited: Event<String>
		let emailTextEdited: Event<String>
		let loginTapped: Event<Void>
	}
}

// MARK: -
extension Welcome.Screen {
	public typealias Strings = Assets.Strings.Welcome

	var prompt: ScreenString {
		{ $0.prompt }
	}

	var namePlaceholder: ScreenString {
		{ $0.Placeholder.name }
	}

	var emailPlaceholder: ScreenString {
		{ $0.Placeholder.email }
	}

	var loginTitle: ScreenString {
		{ $0.Title.login }
	}

	var invalidEmailErrorMessage: ScreenString {
		{ $0.Error.email }
	}

	var canLogIn: Bool {
		!name.isEmpty && !email.isEmpty && !isVerifyingEmail && !hasInvalidEmail
	}
}
