// Copyright © Fleuronic LLC. All rights reserved.

import struct Model.User
import protocol Storable.Prestored

extension User: Prestored {
	public static var prestored: User? {
		.init(
			name: "Jordan Kay",
			email: "jordanekay@mac.com"
		)
	}
}

