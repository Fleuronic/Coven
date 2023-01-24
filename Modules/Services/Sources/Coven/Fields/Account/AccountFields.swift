// Copyright © Fleuronic LLC. All rights reserved.

import struct Model.Account
import protocol Catena.Fields

public protocol AccountFields: Fields where Model == Account.Identified {}
