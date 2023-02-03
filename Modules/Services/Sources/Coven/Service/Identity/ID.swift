// Copyright © Fleuronic LLC. All rights reserved.

import Identity
import PersistDB

extension Identifier where Value: PersistDB.Model {
	static var random: Self {
		.init(rawValue: .init())
	}
}
