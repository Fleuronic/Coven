// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Workflow
import WorkflowUI
import WorkflowContainers

import enum Authentication.Authentication
import struct Coven.User
import struct Coven.PhoneNumber
import struct CovenService.Service
import struct CovenAPI.API
import struct CovenDatabase.Database

extension Authentication.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?

		@Environment(.initialUsername) private var initialUsername
		@Environment(.initialPhoneNumber) private var initialPhoneNumber
	}
}

// MARK: -
extension Authentication.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: AnyWorkflow<AnyScreen, Authentication.Workflow.Output> {
		get async {
			let covenAPI = CovenAPI.API(apiKey: .covenAPIKey)
			let service = Service(
				api: covenAPI,
				database: await Database()
			)

			return Authentication.Workflow(
				service: service,
				initialUsername: initialUsername.map(User.Username.init) ?? .empty,
				initialPhoneNumber: initialPhoneNumber.map(PhoneNumber.init) ?? .empty
			).asAnyWorkflow()
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
	static let covenAPIKey = "N32FEDGy6CEmYyIQQqNOV8Ch54TqEsIYZy7hu4MHUsMbZYnrb5dh8mbyBYaeV2qx"
	static let textbeltAPIKey = "b00e9a1085813963aeafd607f55dfb802829221fjECWQ5nzvAZdybfITn0oaQGpc"
}
