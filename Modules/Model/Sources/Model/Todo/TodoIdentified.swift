// Copyright © Fleuronic LLC. All rights reserved.

import struct Foundation.UUID
import struct Coffin.Identified
import protocol Identity.Identifiable

public extension Todo {
	typealias Identified = Coffin.Identified<Self, UUID>
}

public extension Todo.Identified {
	init(_ todo: Todo = .init()) {
		self.init(
			rawID: .init(),
			value: todo
		)
	}
}

// MARK: -
extension Todo.Identified: Swift.Identifiable {}

extension Todo.Identified: Identifiable {
	public typealias RawIdentifier = UUID

	public var id: Todo.Identified.ID {
		.init(rawValue: rawID)
	}
}
