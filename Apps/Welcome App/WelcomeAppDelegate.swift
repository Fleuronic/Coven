// Copyright © Fleuronic LLC. All rights reserved.

import enum Welcome.Welcome
import class UIKit.UIApplication
import class UIKit.UIWindow
import class UIKit.UIResponder
import protocol Coffin.Storable
import protocol Coffin.Keyed

extension Welcome.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?

		@Environment(.apiKey) private var apiKey
		@Environment(.initialUsername) private var initialUsername
		@Environment(.initialEmail) private var initialEmail
		@Environment(.initialPassword) private var initialPassword
	}
}

// MARK: -
extension Welcome.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: Welcome.Workflow {
		.init(
			api: .init(apiKey: apiKey ?? .defaultAPIKey),
			initialUsername: initialUsername,
			initialEmail: initialEmail,
			initialPassword: initialPassword
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
