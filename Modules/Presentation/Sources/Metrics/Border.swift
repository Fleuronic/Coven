// Copyright © Fleuronic LLC. All rights reserved.

import enum Metric.Border

public extension Border.Width {
	enum Cursor {}
}

// MARK: -
public extension Border.Width.Cursor {
	static let active: Border.Width = 3
	static let inactive: Border.Width = 1
}
