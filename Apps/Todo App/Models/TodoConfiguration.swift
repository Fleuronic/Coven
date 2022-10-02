// Copyright © Fleuronic LLC. All rights reserved.

import Model
import enum Todo.Todo

extension [Model.Todo] {
	enum Configuration: String {
		case single
		case many
	}
}

extension Array.Configuration {
	static var initialTodos: Self? {
		Todo.App.initialTodosConfiguration.flatMap(Self.init)
	}
}

// MARK: -
private extension Todo.App {
	@Environment(.initialTodosConfiguration) static var initialTodosConfiguration
}
