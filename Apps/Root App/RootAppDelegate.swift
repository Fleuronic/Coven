// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import WorkflowUI

import enum Root.Root

extension Root.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?

		@Environment(.apiKey) var apiKey
	}
}

// MARK: -
extension Root.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: Root.Workflow {
		.init(
			api: .init(apiKey: apiKey!)
		)
	}

	// MARK: UIApplicationDelegate
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		window = makeWindow()
		return true
	}
}
