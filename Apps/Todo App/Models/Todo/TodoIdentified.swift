// Copyright © Fleuronic LLC. All rights reserved.

import Model
import enum Todo.Todo
import struct Coffin.Identified
import protocol Coffin.Ephemeral

extension Model.Todo.Identified: Ephemeral {}

// MARK: -
extension [Model.Todo.Identified] {
	static var initial: Self {
		[Model.Todo].initial.map(Identified.init)
	}
}

// MARK: -
extension Array.Configuration {
	static var initialTodos: Self? {
		Todo.App.initialTodosConfiguration.flatMap(Self.init)
	}
}

// MARK: -
private extension Todo.App {
	@Environment(.initialTodosConfiguration) static var initialTodosConfiguration
}
