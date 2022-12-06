// Copyright © Fleuronic LLC. All rights reserved.

import enum Welcome.Welcome
import class UIKit.UIApplication
import class UIKit.UIWindow
import class UIKit.UIResponder
import struct Model.User
import struct Model.PhoneNumber

extension Welcome.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?

		@Environment(.initialUsername) private var initialUsername
		@Environment(.initialPhoneNumber) private var initialPhoneNumber
	}
}

// MARK: -
extension Welcome.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: Welcome.Workflow {
		.init(
			initialUsername: initialUsername.map(User.Username.init),
			initialPhoneNumber: initialPhoneNumber.map(PhoneNumber.init)
		)
	}

	// MARK: UIApplicationDelegate
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		window = makeWindow()
		return true
	}
}

// MARK: -
private extension String {
	static let defaultAPIKey = "DEFAULT_API_KEY"
}
