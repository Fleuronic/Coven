// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import protocol Emissary.MockAPI
import enum Emissary.Request
import enum EmailableAPI.Emailable

import enum Welcome.Welcome

extension Emailable.API: MockAPI {
	public func mockJSONObject(path: String, method: String) -> [String: Any]? {
		let (_, email) = path.firstMatch(of: /email=([^&]*)/)!.output
		let validEmailJSONObject = validEmailJSONObject(for: email)
		let invalidEmailJSONObject = invalidEmailJSONObject(for: email)
		let somethingWentWrongJSONObject = somethingWentWrongJSONObject(for: email)
		let jsonObjects = [
			validEmailJSONObject,
			invalidEmailJSONObject,
			somethingWentWrongJSONObject
		]

		return Configuration.value.map {
			switch $0 {
			case .validEmail:
				return validEmailJSONObject
			case .invalidEmail:
				return invalidEmailJSONObject
			case .somethingWentWrong:
				return somethingWentWrongJSONObject
			case .random:
				return jsonObjects.randomElement()!
			}
		}
	}
}

// MARK: -
private extension Emailable.API {
	func validEmailJSONObject(for email: Substring) -> [String: Any] {
		[
			"email": email,
			"reason": "accepted_email"
		]
	}

	func invalidEmailJSONObject(for email: Substring) -> [String: Any] {
		[
			"email": email,
			"reason": "invalid_domain"
		]
	}

	func somethingWentWrongJSONObject(for email: Substring) -> [String: Any] {
		[
			"message": "Something went wrong."
		]
	}
}
