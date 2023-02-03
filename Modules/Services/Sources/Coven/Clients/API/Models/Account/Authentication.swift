// Copyright © Fleuronic LLC. All rights reserved.

import Catenary
import CovenService

import struct Coven.Account

public extension Account {
	enum Authentication {}
}

// MARK: -
public extension Account.Authentication {
	typealias Result = Swift.Result<Account.Identified.ID, Error>
	typealias State = Request.State<Account.Identified.ID, Error>
	typealias Error = Request.Error<API.Error>
}
