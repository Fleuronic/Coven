// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings
import typealias Ergo.Event

public enum Counter {}

// MARK: -
public extension Counter {
	struct Screen {
		let value: Int
		let increment: Event<Void>
		let decrement: Event<Void>
	}
}

// MARK: -
public extension Counter.Screen {
	typealias Strings = Assets.Strings.Counter
}

extension Counter.Screen {
	var valueText: ScreenString {
		{ $0.value(value) }
	}

	var incrementTitle: String {
		"+"
	}

	var decrementTitle: String {
		"-"
	}
}
