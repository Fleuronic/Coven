// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings

public enum Counter {}

// MARK: -
public extension Counter {
	struct Screen {
		let value: Int
		let increment: () -> Void
		let decrement: () -> Void
	}
}

// MARK: -
public extension Counter.Screen {
	typealias Strings = Assets.Strings.Counter
}

extension Counter.Screen {
//	var valueText: ScreenString {
//		{ $0.value(value) }
//	}

	var valueText: String {
		"The value is \(value)"
	}

	var incrementTitle: String {
		"+"
	}

	var decrementTitle: String {
		"-"
	}
}
