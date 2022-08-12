// Copyright © Fleuronic LLC. All rights reserved.

import UIKit

import enum Welcome.Welcome

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
