// Copyright © Fleuronic LLC. All rights reserved.

import Identity

import struct Coven.Account

public protocol LaunchSpec {
	var authenticatedAccountID: Account.Identified.ID? { get async }
}
