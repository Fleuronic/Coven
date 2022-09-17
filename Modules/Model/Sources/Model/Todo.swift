// Copyright © Fleuronic LLC. All rights reserved.

import struct Foundation.UUID
import protocol Storable.Storable
import protocol Identity.Identifiable

public struct Todo {
	public let id: Todo.ID

	public var title: String
	public var note: String

	public init(
		title: String = "New Todo",
		note: String = "A note describing this todo."
	) {
		id = .init(rawValue: UUID().uuidString)

		self.title = title
		self.note = note
	}
}

// MARK: -
extension Todo: Equatable {}

extension Todo: Codable {}

extension Todo: Identifiable, Swift.Identifiable {}

extension Todo: Storable {}
