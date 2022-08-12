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
				name: "Jordan",
				initialTodos: [
//					.init(
//						title: "Book flights",
//						note: ""
//					),
//					.init(
//						title: "Add trip dates to calendar",
//						note: ""
//					),
//					.init(
//						title: "Buy travel guide",
//						note: ""
//					)
				]
			).mapRendering(BackStackScreen.init)
		)
		window?.makeKeyAndVisible()
		return true
	}
}
