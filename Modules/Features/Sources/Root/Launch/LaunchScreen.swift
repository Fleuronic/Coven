// Copyright © Fleuronic LLC. All rights reserved.

import enum Assets.Strings

public extension Root {
	enum Launch {}
}

// MARK: -
public extension Root.Launch {
	struct Screen {}
}

// MARK: -
extension Root.Launch.Screen {
	public typealias Strings = Assets.Strings
}
