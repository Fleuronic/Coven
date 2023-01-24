// Copyright © Fleuronic LLC. All rights reserved.

import enum Authentication.Authentication
import enum WorkflowContainers.BackStack
import struct Model.User
import struct Model.PhoneNumber
import struct Workflow.AnyWorkflow
import struct WorkflowUI.AnyScreen
import class UIKit.UIApplication
import class UIKit.UIWindow
import class UIKit.UIResponder

extension Authentication.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?

		@Environment(.apiKey) private var apiKey
		@Environment(.initialUsername) private var initialUsername
		@Environment(.initialPhoneNumber) private var initialPhoneNumber
	}
}

// MARK: -
extension Authentication.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: AnyWorkflow<BackStack.Screen<AnyScreen>, Authentication.Workflow.Output> {
		get async {
			Authentication.Workflow(
				api: .init(apiKey: apiKey ?? .defaultAPIKey),
				initialUsername: initialUsername.map(User.Username.init(text:)) ?? .empty,
				initialPhoneNumber: initialPhoneNumber.map(PhoneNumber.init(text:)) ?? .empty
			).mapRendering(BackStack.Screen.init)
		}
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
