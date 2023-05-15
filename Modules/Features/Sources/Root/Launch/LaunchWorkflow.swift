// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI
import Ergo
import EnumKit

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
extension Root.Launch.Workflow {
	typealias Worker = Ergo.Worker<Void, Account.Identified.ID?>
}

// MARK: -
extension Root.Launch.Workflow: Workflow {
	enum Output {
		case unauthenticated
		case authenticated(Account.Identified.ID)
	}

	func makeInitialState() -> Worker {
		.working { await service.authenticatedAccountID }
	}

	func render(state worker: Worker, context: RenderContext<Self>) -> AnyScreen {
		context.render { _ in
			Root.Launch.Screen()
		} running: {
			worker.mapOutput(Action.finish)
		}
	}
}

// MARK: -
private extension Root.Launch.Workflow {
	enum Action: CaseAccessible {
		case finish(Account.Identified.ID?)
	}
}

// MARK: -
extension Root.Launch.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Root.Launch.Workflow<Service>

	func apply(toState _: inout WorkflowType.State) -> WorkflowType.Output? {
		associatedValue().flatMap(WorkflowType.Output.authenticated) ?? .unauthenticated
	}
}
