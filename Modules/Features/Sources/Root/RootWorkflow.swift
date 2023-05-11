// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import WorkflowContainers
import CovenAPI

import enum Counter.Counter
import enum Authentication.Authentication
import struct Coven.Credentials
import struct Coven.User
import struct Coven.Account
import protocol CovenService.LaunchSpec
import protocol CovenService.LoginSpec
import protocol CovenService.CredentialsSpec

public extension Root {
	struct Workflow<
		LaunchService: LaunchSpec,
		LoginService: LoginSpec,
		CredentialsService: CredentialsSpec
	> where
		LoginService.LoginResult == Login.Result,
		CredentialsService.VerificationResult == Coven.Credentials.Verification.Result {
		private let launchService: LaunchService
		private let loginService: LoginService
		private let credentialsService: CredentialsService
		private let initialCredentials: Credentials


		public init(
			launchService: LaunchService,
			loginService: LoginService,
			credentialsService: CredentialsService,
			initialCredentials: Credentials
		) {
			self.launchService = launchService
			self.loginService = loginService
			self.credentialsService = credentialsService
			self.initialCredentials = initialCredentials
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
			loginService: loginService,
			credentialsService: credentialsService,
			initialCredentials: initialCredentials
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
	typealias WorkflowType = Root.Workflow<LaunchService, LoginService, CredentialsService>

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
