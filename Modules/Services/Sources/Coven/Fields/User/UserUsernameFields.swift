// Copyright © Fleuronic LLC. All rights reserved.

import struct Model.User
import struct Schemata.Projection

public struct UserUsernameFields {
	public let id: User.Identified.ID
	public let username: User.Username
}

// MARK: -
extension UserUsernameFields: UserFields {
	// MARK: ModelProjection
	public static let projection = Projection<User.Identified, Self>(
		Self.init,
		User.Identified.idKeyPath,
		\.value.username
	)
}
