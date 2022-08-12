// Copyright © Fleuronic LLC. All rights reserved.

import enum Welcome.Welcome
import enum EmailableAPI.Emailable

extension Emailable.API {
	enum Configuration: String {
		case validEmail
		case invalidEmail
		case somethingWentWrong
		case random
	}
}

// MARK: -
extension Emailable.API.Configuration {
	static var value: Self? {
		Welcome.App.apiConfiguration.flatMap(Self.init)
	}
}

// MARK: -
private extension Welcome.App {
	@Environment(.apiConfiguration) static var apiConfiguration
}
