// Copyright © Fleuronic LLC. All rights reserved.

public struct Todo {
	public var title: String
	public var note: String

	public init(
		title: String = "New Todo",
		note: String = "A note describing this todo."
	) {
		self.title = title
 		self.note = note
	}
}

// MARK: -
extension Todo: Equatable {}

extension Todo: Codable {}
