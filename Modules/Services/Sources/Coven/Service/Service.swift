// Copyright © Fleuronic LLC. All rights reserved.

import protocol Catenary.API
import protocol Catenoid.Database

public struct Service<API: Catenary.API, Database: Catenoid.Database> {
	let api: API
	let database: Database

	public init(
		api: API,
		database: Database
	) {
		self.api = api
		self.database = database
	}
}
