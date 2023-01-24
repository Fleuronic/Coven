// Copyright © Fleuronic LLC. All rights reserved.

//import enum Catenary.Request
//import enum API.Coven
//import enum Authentication.Authentication
//import protocol Catenary.MockAPI
//
//extension Coven.API: MockAPI {
//	public func mockJSONObject(path: String, method: String) -> [String: Any]? {
//		let (_, email) = path.firstMatch(of: /email=([^&]*)/)!.output
//
//		return Configuration.value.map {
//			switch $0 {
//			case .validEmail:
//				return [
//					"email": email,
//					"reason": "accepted_email"
//				]
//			case .invalidEmail:
//				return [
//					"email": email,
//					"reason": "invalid_domain"
//				]
//			case .somethingWentWrong:
//				return [
//					"message": "Something went wrong."
//				]
//			}
//		}
//	}
//}
