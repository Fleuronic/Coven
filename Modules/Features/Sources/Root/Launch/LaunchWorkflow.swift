// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import Ergo
import CovenAPI

import struct Coven.Account
import protocol CovenService.LaunchSpec

extension Root.Launch {
	struct Workflow<Service: LaunchSpec> {
		private let service: Service

		public init(service: Service) {
			self.service = service
		}
	}
}

// MARK: -
extension Root.Launch.Workflow: Workflow {
	typealias Rendering = AnyScreen

	enum Output {
		case unauthenticated
		case authenticated(Account.Identified.ID)
	}

	struct State {}

	func makeInitialState() -> State {
		.init()
	}

	func render(state: State, context: RenderContext<Self>) -> Rendering {
		context.run(
			state
				.worker(using: service)
				.mapOutput(Action.finish)
		)

		return Root.Launch.Screen().asAnyScreen()
	}
}

// MARK: -
private extension Root.Launch.Workflow {
	enum Action {
		case finish(Account.Identified.ID?)
	}
}

// MARK: -
private extension Root.Launch.Workflow.State {
	func worker(using service: Service) -> RequestWorker<Account.Identified.ID?> {
		.init { await service.authenticatedAccountID }
	}
}

// MARK: -
extension Root.Launch.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Root.Launch.Workflow<Service>

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case .finish(.none):
			return .unauthenticated
		case let .finish(.some(accountID)):
			return .authenticated(accountID)
		}
	}
}
