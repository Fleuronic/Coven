// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Workflow
import WorkflowUI
import WorkflowContainers

import enum Root.Root
import struct CovenService.Service
import struct CovenAPI.API
import struct TextbeltAPI.API
import struct CovenDatabase.Database

extension Root.App {
	@UIApplicationMain
	final class Delegate: UIResponder {
		var window: UIWindow?
	}
}

// MARK: -
extension Root.App.Delegate: AppDelegate {
	// MARK: AppDelegate
	var workflow: AnyWorkflow<AnyScreen, Never> {
		get async {
			let database = await Database()
			let covenAPI = CovenAPI.API(apiKey: .covenAPIKey)
			let textbeltAPI = TextbeltAPI.API(apiKey: .textbeltAPIKey)

			return Root.Workflow(
				launchService: database,
				authenticationService: Service(
					api: covenAPI,
					database: database
				),
				credentialsService: covenAPI,
				otpService: textbeltAPI
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
