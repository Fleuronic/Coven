// Copyright © Fleuronic LLC. All rights reserved.

import XCTest
import WorkflowTesting
import EnumKit

import enum Demo.Demo

@testable import Ergo
@testable import WorkflowContainers
@testable import WorkflowReactiveSwift
@testable import enum DemoList.DemoList
@testable import struct WorkflowUI.AnyScreen

final class DemoListWorkflowTests: XCTestCase {
	func testDemo() {
		let demo = Demo.swiftUI
        let state = DemoList.Workflow().makeInitialState()
        
		DemoList.Workflow.Action
			.tester(withState: state)
			.send(action: .demo(demo))
			.assert(output: demo)
	}

    func testShowDemos() {
        let demos = Demo.allCases
        let workflow = DemoList.Workflow()
        
        DemoList.Workflow.Action
            .tester(withState: workflow.makeInitialState())
            .send(action: .show(demos))
            .verifyState { XCTAssertEqual($0.demos, demos) }
            .assertNoOutput()
        
        DemoList.Workflow.Action
            .tester(
                withState: .init(
                    demos: demos,
                    updateWorker: .ready(to: workflow.updateDemos)
                )
            )
            .send(action: .show(nil))
            .verifyState { XCTAssertEqual($0.demos, demos) }
            .assertNoOutput()
    }
    
    func testUpdateDemos() {
        DemoList.Workflow.Action
            .tester(withState: DemoList.Workflow().makeInitialState())
            .send(action: .updateDemos)
            .verifyState { XCTAssert($0.updateWorker.isWorking) }
            .assertNoOutput()
    }

	func testRenderingScreen() throws {
		let demos = Demo.allCases

		try DemoList.Workflow()
			.renderTester()
			.expectWorkflow(
				type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
				producingRendering: ()
			)
			.render { item in
				let alertScreen = try XCTUnwrap(item.screen.wrappedScreen as? Alert.Screen<DemoList.Screen>)
				let screen = alertScreen.baseScreen
				XCTAssertEqual(screen.demos, demos)
                
                let barContent = try XCTUnwrap(item.barVisibility[expecting: Bar.Content.self])
                XCTAssertEqual(barContent.title, "Workflow Demo")
			}
            .verifyState { state in
                XCTAssertEqual(state.demos, demos)
                XCTAssertTrue(state.updateWorker.isReady)
            }
	}

    func testRenderingUpdateDemos() throws {
        let workflow = DemoList.Workflow()
        
        try workflow
            .renderTester()
            .expectWorkflow(
                type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
                producingRendering: ()
            )
            .render { item in
                let barContent = try XCTUnwrap(item.barVisibility[expecting: Bar.Content.self])
                let rightItem = try XCTUnwrap(barContent.rightItem)
                XCTAssertEqual(rightItem.content, .text("Update"))
                rightItem.handler()
            }
            .assert(action: DemoList.Workflow.Action.updateDemos)
            .assertNoOutput()
        
        try workflow
            .renderTester(
                initialState: .init(
                    demos: Demo.allCases,
                    updateWorker: .working(to: workflow.updateDemos)
                )
            )
            .expectWorkflow(
                type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
                producingRendering: ()
            )
            .render { item in
                let barContent = try XCTUnwrap(item.barVisibility[expecting: Bar.Content.self])
                let rightItem = try XCTUnwrap(barContent.rightItem)
                XCTAssertFalse(rightItem.isEnabled)
            }
            .assertNoOutput()
    }

	func testRenderingSelectDemo() throws {
		let demo = Demo.swiftUI

		try DemoList.Workflow()
			.renderTester()
			.expectWorkflow(
				type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
				producingRendering: ()
			)
			.render { backStackScreen in
				let wrappedScreen = backStackScreen.screen.wrappedScreen
				let alertScreen = try XCTUnwrap(wrappedScreen as? Alert.Screen<DemoList.Screen>)
				let demoListScreen = alertScreen.baseScreen
				demoListScreen.selectDemo(demo)
			}
			.assert(action: DemoList.Workflow.Action.demo(demo))
			.assert(output: demo)
	}
    
    func testRenderingAlert() throws {
        let workflow = DemoList.Workflow()

        try DemoList.Workflow()
            .renderTester(
                initialState: .init(
                    demos: Demo.allCases,
                    updateWorker: .init(
                        state: .failed(.loadError),
                        return: workflow.updateDemos
                    )
                )
            )
            .expectWorkflow(
                type: WorkerWorkflow<DemoList.Workflow.UpdateWorker>.self,
                producingRendering: ()
            )
            .render { backStackScreen in
                let wrappedScreen = backStackScreen.screen.wrappedScreen
                let alertScreen = try XCTUnwrap(wrappedScreen as? Alert.Screen<DemoList.Screen>)
                let alert = try XCTUnwrap(alertScreen.alert)
                XCTAssertEqual(alert.title, "Update Error")
                XCTAssertEqual(alert.message, "The demos could not be updated. Please try again later.")
                
                let dismissAction = try XCTUnwrap(alert.actions.first)
                XCTAssertEqual(dismissAction.title, "Dismiss")
                dismissAction.handler()
            }
            .verifyState { XCTAssert($0.updateWorker.isReady) }
            .assertNoAction()
            .assertNoOutput()
    }
    
    func testUpdateWorkerSuccess() throws {
        let workflow = DemoList.Workflow()
        let expectation = expectation(description: "UpdateDemos")
        
        DemoList.Workflow.UpdateWorker
            .working(to: workflow.updateDemos)
            .run()
            .startWithValues { result in
                switch result {
                case .success(Demo.allCases):
                    expectation.fulfill()
                default:
                    break
                }
            }
        
        wait(for: [expectation])
    }
    
    func testUpdateWorkerFailureLoadError() throws {
        let workflow = DemoList.Workflow()
        let expectation = expectation(description: "UpdateDemos")
        
        DemoList.Workflow.UpdateWorker
            .working(to: workflow.updateDemos)
            .run()
            .startWithValues { result in
                switch result {
                case .failure(.loadError):
                    expectation.fulfill()
                default:
                    break
                }
            }
        
        wait(for: [expectation])
    }
    
    func testUpdateWorkerFailureSleepError() throws {
        let workflow = DemoList.Workflow()
        let expectation = expectation(description: "UpdateDemos")
        
        DemoList.Workflow.UpdateWorker
            .working(to: workflow.updateDemos)
            .run()
            .startWithValues { result in
                switch result {
                case let .failure(.sleepError(error)):
                    expectation.fulfill()
                default:
                    break
                }
            }
        
        wait(for: [expectation])
    }
}

// MARK: -
extension Bar.Visibility: CaseAccessible {}
