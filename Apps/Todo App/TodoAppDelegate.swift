// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import BackStackContainer
import Workflow
import WorkflowUI
import Model

import enum Todo.Todo

extension Todo.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?
	}
}

// MARK: -
extension Todo.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: AnyWorkflow<BackStackScreen<AnyScreen>, Todo.Workflow.Output> {
		Todo.Workflow(
			name: User.stored!.name,
			canLogOut: false
		).mapRendering(BackStackScreen.init)
	}

	// MARK: UIApplicationDelegate
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		User.prestore()
		Model.Todo.prestore()
		window = makeWindow()
		return true
	}
}
