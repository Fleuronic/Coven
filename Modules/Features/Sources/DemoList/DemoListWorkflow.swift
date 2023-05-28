// Copyright © Fleuronic LLC. All rights reserved.

import Ergo
import Workflow
import WorkflowUI
import WorkflowContainers

import enum Demo.Demo

public extension DemoList {
	struct Workflow {
        public init() {}
	}
}

// MARK: -
extension DemoList.Workflow {
	enum Action: Equatable {
        case show([Demo]?)
        case demo(Demo)
        case updateDemos
	}
}

// MARK: -
extension DemoList.Workflow: Workflow {
	public typealias Output = Demo
    
    fileprivate typealias UpdateWorker = Worker<Void, Result<[Demo], Error>>
    
    public struct State {
        fileprivate var demos: [Demo]
        fileprivate let updateWorker: UpdateWorker
    }
    
    public func makeInitialState() -> State {
        .init(
            demos: Demo.allCases,
            updateWorker: .ready(to: updateDemos)
        )
    }

	public func render(
		state: State,
		context: RenderContext<Self>
	) -> BackStack.Item {
		context.render { (sink: Sink<Action>) in
			.init(
                screen: Alert.Screen(
                    baseScreen: DemoList.Screen(
                        demos: state.demos,
                        selectDemo: { sink.send(.demo($0)) },
                        isUpdatingDemos: state.isUpdatingDemos
                    ),
                    alert: state.alert
                ).asAnyScreen(),
				barContent: .init(
                    title: "Workflow Demo",
                    rightItem: .init(
                        content: .text("Update"),
                        isEnabled: !state.isUpdatingDemos,
                        handler: { sink.send(.updateDemos) }
                    )
                )
			)
        } running: {
            state.updateWorker.mapSuccess(Action.show)
        }
	}
}

// MARK: -
private extension DemoList.Workflow {
    enum Error: Swift.Error {
        case loadError
        case sleepError(Swift.Error)
    }
    
    func updateDemos() async -> Result<[Demo], Error> {
        do {
            try await Task.sleep(nanoseconds: .updateTime)
            return Bool.random() ? .success(Demo.allCases) : .failure(.loadError)
        } catch {
            return .failure(.sleepError(error))
        }
    }
}

// MARK: -
private extension DemoList.Workflow.State {
    var isUpdatingDemos: Bool {
        updateWorker.isWorking
    }
    
    var alert: Alert? {
        updateWorker.errorContext
            .map(\.1)
            .map(makeAlert)
    }
    
    func makeAlert(dismissHandler: @escaping () -> Void) -> Alert {
        .init(
            title: "Update Error",
            message: "The demos could not be updated. Please try again later.",
            actions: [
                .init(
                    title: "Dismiss",
                    handler: dismissHandler
                )
            ]
        )
    }
}

// MARK: -
extension DemoList.Workflow.Action: WorkflowAction {
	public typealias WorkflowType = DemoList.Workflow

    public func apply(toState state: inout WorkflowType.State) -> Demo? {
        switch self {
        case let .show(demos?):
            state.demos = demos
        case let .demo(demo):
            return demo
        case .updateDemos:
            state.updateWorker.start()
        default:
            break
        }
        return nil
	}
}

private extension UInt64 {
    static let updateTime: Self = 500_000_000
}
