// Copyright © Fleuronic LLC. All rights reserved.

public extension Emailable.API {
	func verify(_ email: String) async -> Emailable.Email.Verification.Result {
		let path = "verify?email=\(email)&api_key=\(apiKey)"
		return await getResource(at: path)
	}
}
