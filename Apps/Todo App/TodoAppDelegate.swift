// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import BackStackContainer
import WorkflowUI

import enum Todo.Todo

extension Todo.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?
	}
}

// MARK: -
extension Todo.App.Delegate: UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		window = .init(frame: UIScreen.main.bounds)
		window?.rootViewController = ContainerViewController(
			workflow: Todo.Workflow(
				name: "Jordan"
			).mapRendering(BackStackScreen.init)
		)
		window?.makeKeyAndVisible()
		return true
	}
}
