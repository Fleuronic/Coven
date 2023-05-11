// Copyright © Fleuronic LLC. All rights reserved.

import Ergo

import enum Assets.Strings

public extension Counter {
	struct Screen {
		let value: Int
		let increment: Event<Void>
		let decrement: Event<Void>
	}
}

// MARK: -
public extension Counter.Screen {
	typealias Strings = Assets.Strings
}

extension Counter.Screen {
	var text: String {
		"The value "
	}
}
