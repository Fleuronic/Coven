// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings
import typealias Ergo.Event

extension Todo.List {
	struct Screen {
		let todoTitles: [String]
		let rowSelected: Event<Int>
		let rowDeleted: Event<Int>
	}
}

// MARK: -
extension Todo.List.Screen {
	typealias Strings = Assets.Strings.Todo.List

	var emptyStateMessage: ScreenString {
		{ $0.Message.emptyState }
	}

	var isEmpty: Bool {
		todoTitles.isEmpty
	}
}
