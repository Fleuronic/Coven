// Copyright © Fleuronic LLC. All rights reserved.

//import enum Authentication.Authentication
//import enum API.Coven
//
//extension Coven.API {
//	enum Configuration: String {
//		case validEmail
//		case invalidEmail
//		case somethingWentWrong
//	}
//}
//
//// MARK: -
//extension Coven.API.Configuration {
//	static var value: Self? {
//		Authentication.App.apiConfiguration.flatMap(Self.init)
//	}
//}
//
//// MARK: -
//private extension Authentication.App {
//	@Environment(.apiConfiguration) static var apiConfiguration
//}
