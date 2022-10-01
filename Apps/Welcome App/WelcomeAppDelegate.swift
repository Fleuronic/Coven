// Copyright © Fleuronic LLC. All rights reserved.

import enum Welcome.Welcome
import class UIKit.UIApplication
import class UIKit.UIWindow
import class UIKit.UIResponder
import protocol Storable.Storable
import protocol Storable.Keyed

extension Welcome.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?

		@Environment(.apiKey) private var apiKey
		@Environment(.initialName) private var initialName
		@Environment(.initialEmail) private var initialEmail
	}
}

// MARK: -
extension Welcome.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: Welcome.Workflow {
		.init(
			api: .init(apiKey: apiKey ?? .defaultAPIKey),
			initialName: initialName,
			initialEmail: initialEmail
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
