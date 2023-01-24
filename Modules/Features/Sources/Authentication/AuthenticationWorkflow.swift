// Copyright © Fleuronic LLC. All rights reserved.

import enum WorkflowContainers.BackStack
import struct Model.Account
import struct Model.User
import struct Model.PhoneNumber
import struct Coven.API
import struct Coven.Database
import struct Coven.AccountPhoneNumberFields
import struct Coven.UserUsernameFields
import struct Coven.AccountUsernameFields
import class Workflow.RenderContext
import protocol Workflow.Workflow
import protocol Workflow.WorkflowAction

import Schemata
import PersistDB

public extension Authentication {
	struct Workflow {
		private let api: Coven.API
		private let initialUsername: User.Username
		private let initialPhoneNumber: PhoneNumber

		public init(
			api: Coven.API,
			initialUsername: User.Username,
			initialPhoneNumber: PhoneNumber
		) {
			self.api = api
			self.initialUsername = initialUsername
			self.initialPhoneNumber = initialPhoneNumber
		}
	}
}

// MARK: -
extension Authentication.Workflow: Workflow {
	public typealias Rendering = [BackStack.Item]

	public struct State {
		var input: Input
	}

	public func makeInitialState() -> State {
		.init(
			input: .credentials
		)
	}

	public func render(state: State, context: RenderContext<Authentication.Workflow>) -> Rendering {
		let credentialsItem = credentialsItem(with: state, in: context)

		switch state.input {
		case .credentials:
			return [credentialsItem]
		case let .pin(pin, account):
			let pinItem = pinItem(with: state, in: context, for: account, matching: pin)
			return [credentialsItem, pinItem]
		}
	}
}

// MARK: -
private extension Authentication.Workflow {
	enum Action {
		case confirmIdentity(Account, String)
		case authenticate(Account)
		case cancel
	}

	func credentialsItem(with state: State, in context: RenderContext<Self>) -> BackStack.Item {
		let workflow = Authentication.Credentials.Workflow(
			api: api,
			initialUsername: initialUsername,
			initialPhoneNumber: initialPhoneNumber
		)

		return workflow
			.mapOutput(Action.confirmIdentity)
			.rendered(in: context)
	}

	func pinItem(with state: State, in context: RenderContext<Self>, for account: Account, matching pin: String) -> BackStack.Item {
		let workflow = Authentication.PIN.Workflow(
			api: api,
			pin: pin
		)

		return workflow
			.mapOutput { pinAction(for: $0, authenticating: account) }
			.rendered(in: context)
	}

	func pinAction(for output: Authentication.PIN.Workflow.Output, authenticating account: Account) -> Action {
		switch output {
		case .confirmation:
			return .authenticate(account)
		case .cancellation:
			return .cancel
		}
	}
}

// MARK: -
extension Authentication.Workflow.State {
	enum Input {
		case credentials
		case pin(String, authenticating: Account)
	}
}

// MARK: -
extension Authentication.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Authentication.Workflow

	func apply(toState state: inout Authentication.Workflow.State) -> Authentication.Workflow.Output? {
		switch self {
		case let .confirmIdentity(account, pin):
			state.input = .pin(pin, authenticating: account)
		case .authenticate:
			break
		case .cancel:
			state.input = .credentials
		}
		return nil
	}
}
