// Copyright © Fleuronic LLC. All rights reserved.

import enum Todo.Todo
import class UIKit.UIApplication
import class UIKit.UIWindow
import class UIKit.UIResponder
import struct WorkflowUI.AnyScreen
import struct Workflow.AnyWorkflow

import WorkflowContainers

extension Todo.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?

		@Environment(.name) private var name
	}
}

// MARK: -
extension Todo.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: AnyWorkflow<BackStackScreen<AnyScreen>, Todo.Workflow.Output> {
		Todo.Workflow(
			name: name!,
			initialTodos: .initial
		).mapRendering(BackStackScreen.init)
	}

	// MARK: UIApplicationDelegate
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		window = makeWindow()
		return true
	}
}
