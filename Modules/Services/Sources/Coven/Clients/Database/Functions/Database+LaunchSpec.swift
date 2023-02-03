// Copyright © Fleuronic LLC. All rights reserved.

import Catenoid

import struct Coven.Account
import protocol CovenService.LaunchSpec

extension Database: LaunchSpec {
	public var authenticatedAccountID: Account.Identified.ID? {
		get async {
			await fetch(Account.Identified.self).value.first
		}
	}
}
