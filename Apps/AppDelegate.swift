// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Workflow
import WorkflowUI

protocol AppDelegate: UIApplicationDelegate {
	associatedtype AppWorkflow: AnyWorkflowConvertible where AppWorkflow.Rendering: Screen

	var workflow: AppWorkflow { get }
}

// MARK: -
extension AppDelegate {
	func makeWindow() -> UIWindow {
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.makeKeyAndVisible()
		window.rootViewController = ContainerViewController(workflow: workflow)
		return window
	}
}
