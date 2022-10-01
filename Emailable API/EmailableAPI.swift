// Copyright © Fleuronic LLC. All rights reserved.

import enum Emissary.Request
import enum EmailableAPI.Emailable
import enum Welcome.Welcome
import protocol Emissary.MockAPI

extension Emailable.API: MockAPI {
	public func mockJSONObject(path: String, method: String) -> [String: Any]? {
		let (_, email) = path.firstMatch(of: /email=([^&]*)/)!.output

		return Configuration.value.map {
			switch $0 {
			case .validEmail:
				return [
					"email": email,
					"reason": "accepted_email"
				]
			case .invalidEmail:
				return [
					"email": email,
					"reason": "invalid_domain"
				]
			case .somethingWentWrong:
				return [
					"message": "Something went wrong."
				]
			}
		}
	}
}
