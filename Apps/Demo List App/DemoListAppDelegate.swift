// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Workflow
import WorkflowUI
import WorkflowContainers

import enum Demo.Demo
import enum DemoList.DemoList
import struct DemoAPI.API

extension DemoList.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?
		
		@Environment(.canUpdateDemos) private var canUpdateDemos
	}
}

// MARK: -
extension DemoList.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: AnyWorkflow<AnyScreen, Demo> {
		DemoList.Workflow(
			service: mockAPI,
			canSelectDemos: false
		).mapRendering { item in
			BackStack.Screen(items: [item]).asAnyScreen()
		}
	}

	// MARK: UIApplicationDelegate
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		window = makeWindow()
		return true
	}
}

// MARK: -
private extension DemoList.App.Delegate {
	var mockAPI: MockDemoAPI {
		.init(
			result: self.canUpdateDemos ? .success(Demo.allCases) : .failure(.loadError)
		)
	}
}
