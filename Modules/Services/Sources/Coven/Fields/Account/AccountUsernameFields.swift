// Copyright © Fleuronic LLC. All rights reserved.

import struct Model.Account
import struct Model.User
import struct Schemata.Projection

public struct AccountUsernameFields {
	public let id: Account.Identified.ID
	public let username: User.Username
}

// MARK: -
extension AccountUsernameFields: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try! decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Account.Identified.ID.self, forKey: .id)

		let userContainer = try! container.nestedContainer(keyedBy: UserCodingKeys.self, forKey: .user)
		username = try userContainer.decode(User.Username.self, forKey: .username)
	}
}

extension AccountUsernameFields: AccountFields {
	// MARK: ModelProjection
	public static let projection = Projection<Account.Identified, Self>(
		Self.init,
		Account.Identified.idKeyPath,
		\.user.value.username
	)
}

// MARK: -
private extension AccountUsernameFields {
	enum CodingKeys: String, CodingKey {
		case id
		case user
	}

	enum UserCodingKeys: String, CodingKey {
		case username
	}
}
