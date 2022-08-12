import XCTest

import struct Model.Todo

class TodoTests: XCTestCase {
	func testTodo() throws {
		let title = "Title"
		let note = "Note"
		let todo = Todo(title: title, note: note)

		XCTAssertEqual(todo.title, title)
		XCTAssertEqual(todo.note, note)
	}
}
