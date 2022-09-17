// Copyright © Fleuronic LLC. All rights reserved.

import struct Model.Todo
import protocol Storable.Prestored

extension Todo: Prestored {
	public static var prestoredValues: [Self] {
		[
			.init(
				title: "Beep Title",
				note: "Beep Note"
			)
		]
	}
}
