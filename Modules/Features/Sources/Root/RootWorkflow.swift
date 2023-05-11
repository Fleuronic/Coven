// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import CovenAPI

import enum Counter.Counter
import enum Authentication.Authentication
import struct Coven.Credentials
import struct Coven.User
import struct Coven.PhoneNumber
import struct Coven.Account
import protocol CovenService.LaunchSpec
import protocol CovenService.LoginSpec

public extension Root {
	struct Workflow<
		LaunchService: LaunchSpec,
		AuthenticationService: LoginSpec
	>
	where
		AuthenticationService.AuthenticationResult == Account.Authentication.Result,
		AuthenticationService.VerificationResult == Coven.Credentials.Verification.Result {
		private let launchService: LaunchService
		private let authenticationService: AuthenticationService
		private let initialUsername: Coven.User.Username
		private let initialPhoneNumber: Coven.PhoneNumber


		public init(
			launchService: LaunchService,
			authenticationService: AuthenticationService,
			initialUsername: Coven.User.Username,
			initialPhoneNumber: Coven.PhoneNumber

		) {
			self.launchService = launchService
			self.authenticationService = authenticationService
			self.initialUsername = initialUsername
			self.initialPhoneNumber = initialPhoneNumber
		}
	}
}

// MARK: -
extension Root.Workflow {
	enum Action {
		case authenticate
		case activate(Account.Identified.ID)
	}
}

// MARK: -
extension Root.Workflow: Workflow {
	public typealias Rendering = AnyScreen

	public enum State {
		case launch
		case main
		case authentication
	}

	public func makeInitialState() -> State {
		.launch
	}

	public func render(state: State, context: RenderContext<Self>) -> Rendering {
		switch state {
		case .launch:
			return launchScreen(in: context)
		case .main:
			return mainScreen(in: context)
		case .authentication:
			return authenticationScreen(in: context)
		}
	}
}

// MARK: -
private extension Root.Workflow {
	func launchScreen(in context: RenderContext<Self>) -> AnyScreen {
		let workflow = Root.Launch.Workflow(
			service: launchService
		)

		return workflow
			.mapOutput(authenticationAction)
			.rendered(in: context)
			.asAnyScreen()
	}

	func mainScreen(in context: RenderContext<Self>) -> AnyScreen {
		let workflow = Counter.Workflow()

		return workflow
			.rendered(in: context)
			.asAnyScreen()
	}

	func authenticationScreen(in context: RenderContext<Self>) -> AnyScreen {
		let workflow = Authentication.Workflow(
			service: authenticationService,
			initialUsername: initialUsername,
			initialPhoneNumber: initialPhoneNumber
		)

		return workflow
			.mapOutput(Action.activate)
			.rendered(in: context)
			.asAnyScreen()
	}

	func authenticationAction(for output: Root.Launch.Workflow<LaunchService>.Output) -> Action {
		switch output {
		case .unauthenticated:
			return .authenticate
		case let .authenticated(accountID):
			return .activate(accountID)
		}
	}
}

// MARK: -
extension Root.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Root.Workflow<LaunchService, AuthenticationService>

	func apply(toState state: inout WorkflowType.State) -> Never? {
		switch self {
		case .authenticate:
			state = .authentication
		case .activate:
			state = .main
		}
		return nil
	}
}
