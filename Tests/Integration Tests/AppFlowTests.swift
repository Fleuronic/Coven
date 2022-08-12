import XCTest
import Workflow
import enum Assets.Strings

@testable import WorkflowUI
@testable import BackStackContainer
@testable import Todo
@testable import enum Root.Root
@testable import enum Welcome.Welcome
@testable import enum Todo.Todo

class AppFlowTests: XCTestCase {
	func testAppFlow() throws {
		let name = "Jordan"
		let title = "Title"
		let note = "Note"
		let updatedTodoTitle = "Updated Title"
		let updatedTodoNote = "Updated Note"

		try logIn(with: name)
		try addNewTodo()
		try verifyTodoAdded()
		try selectFirstTodo()
		try editTodoTitle(to: updatedTodoTitle)
		try editTodoNote(to: updatedTodoNote)
		try saveChanges()
		try verifyTodoTitleUpdated(to: updatedTodoTitle)
		try selectFirstTodo()
		try editTodoTitle(to: title)
		try editTodoNote(to: note)
		try discardChanges()
		try verifyTodoTitleUpdated(to: updatedTodoTitle)
		try logOut()
		try verifyLoggedOut()
	}
}

private extension AppFlowTests {
	var items: [BackStackItem] {
		workflowHost.rendering.value.items
	}

	func logIn(with name: String) throws {
		XCTAssertEqual(items.count, 1)

		let welcomeScreen = try XCTUnwrap(items[0].screen.wrappedScreen as? Welcome.Screen)
		welcomeScreen.nameTextEdited(name)
		welcomeScreen.loginTapped(())
	}

	func selectFirstTodo() throws {
		XCTAssertEqual(items.count, 2)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)

		let todoListScreen = try XCTUnwrap(items[1].screen.wrappedScreen as? Todo.List.Screen)
		XCTAssertFalse(todoListScreen.todoTitles.isEmpty)

		todoListScreen.rowSelected(0)
	}

	func editTodoTitle(to title: String) throws {
		XCTAssertEqual(items.count, 3)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)
		XCTAssertNotNil(items[1].screen.wrappedScreen as? Todo.List.Screen)

		let todoEditScreen = try XCTUnwrap(items[2].screen.wrappedScreen as? Todo.Edit.Screen)
		todoEditScreen.titleTextEdited(title)
	}

	func editTodoNote(to note: String) throws {
		XCTAssertEqual(items.count, 3)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)
		XCTAssertNotNil(items[1].screen.wrappedScreen as? Todo.List.Screen)

		let todoEditScreen = try XCTUnwrap(items[2].screen.wrappedScreen as? Todo.Edit.Screen)
		todoEditScreen.noteTextEdited(note)
	}

	func saveChanges() throws {
		XCTAssertEqual(items.count, 3)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)
		XCTAssertNotNil(items[1].screen.wrappedScreen as? Todo.List.Screen)
		XCTAssertNotNil(items[2].screen.wrappedScreen as? Todo.Edit.Screen)

		guard case let .visible(barContent) = items[2].barVisibility else { XCTFail(); return }
		guard case let .button(saveButton) = barContent.rightItem else { XCTFail(); return }
		guard case let .text(saveButtonText) = saveButton.content else { XCTFail(); return }

		XCTAssertEqual(saveButtonText, Strings.Todo.Edit.Title.Button.save)

		saveButton.handler()
	}

	func discardChanges() throws {
		XCTAssertEqual(items.count, 3)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)
		XCTAssertNotNil(items[1].screen.wrappedScreen as? Todo.List.Screen)
		XCTAssertNotNil(items[2].screen.wrappedScreen as? Todo.Edit.Screen)

		guard case let .visible(barContent) = items[2].barVisibility else { XCTFail(); return }
		guard case let .button(backButton) = barContent.leftItem else { XCTFail(); return }
		guard case .back = backButton.content else { XCTFail(); return }

		backButton.handler()
	}

	func verifyTodoTitleUpdated(to title: String) throws {
		XCTAssertEqual(items.count, 2)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)

		let todoListScreen = try XCTUnwrap(items[1].screen.wrappedScreen as? Todo.List.Screen)
		XCTAssertFalse(todoListScreen.todoTitles.isEmpty)
		XCTAssertEqual(todoListScreen.todoTitles[0], title)
	}

	func addNewTodo() throws {
		XCTAssertEqual(items.count, 2)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)
		XCTAssertNotNil(items[1].screen.wrappedScreen as? Todo.List.Screen)

		guard case let .visible(barContent) = items[1].barVisibility else { XCTFail(); return }
		guard case let .button(newTodoButton) = barContent.rightItem else { XCTFail(); return }
		guard case let .text(newTodoButtonText) = newTodoButton.content else { XCTFail(); return }

		XCTAssertEqual(newTodoButtonText, Strings.Todo.List.Title.Button.newTodo)

		newTodoButton.handler()
	}

	func verifyTodoAdded() throws {
		XCTAssertEqual(items.count, 2)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)

		let todoListScreen = try XCTUnwrap(items[1].screen.wrappedScreen as? Todo.List.Screen)
		XCTAssertEqual(todoListScreen.todoTitles.count, 1)
	}

	func logOut() throws {
		XCTAssertEqual(items.count, 2)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)
		XCTAssertNotNil(items[1].screen.wrappedScreen as? Todo.List.Screen)

		guard case let .visible(barContent) = items[1].barVisibility else { XCTFail(); return }
		guard case let .button(backButton) = barContent.leftItem else { XCTFail(); return }
		guard case .back = backButton.content else { XCTFail(); return }

		backButton.handler()
	}

	func verifyLoggedOut() throws {
		XCTAssertEqual(items.count, 1)
		XCTAssertNotNil(items[0].screen.wrappedScreen as? Welcome.Screen)
	}
}

private let workflowHost = WorkflowHost(workflow: Root.Workflow())
