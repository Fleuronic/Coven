// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import Ergo

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

	struct State {
		fileprivate var worker: Worker
	}

	func makeInitialState() -> State {
		.init(worker: .working(by: { await service.authenticatedAccountID } ))
	}

	func render(state: State, context: RenderContext<Self>) -> Rendering {
		context.render { (sink: Sink<Action>) in
			Root.Launch.Screen()
		} running: {
			state.worker.mapOutput(Action.finish)
		}
	}
}

// MARK: -
private extension Root.Launch.Workflow {
	typealias Worker = Ergo.Worker<Void, Account.Identified.ID?>

	enum Action {
		case finish(Account.Identified.ID?)
	}
}

// MARK: -
extension Root.Launch.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Root.Launch.Workflow<Service>

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case let .finish(accountID):
			return accountID.map(WorkflowType.Output.authenticated) ?? .unauthenticated
		}
	}
}
