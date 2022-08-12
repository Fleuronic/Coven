// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings
import typealias Ergo.Event

extension Todo.Edit {
	struct Screen {
		let title: String
		let note: String
		let titleTextEdited: Event<String>
		let noteTextEdited: Event<String>
	}
}

// MARK: -
extension Todo.Edit.Screen {
	typealias Strings = Assets.Strings.Todo.Edit

	var titlePlaceholder: ScreenString {
		{ $0.Placeholder.title }
	}
}
