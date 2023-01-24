// Copyright © Fleuronic LLC. All rights reserved.

import struct Model.User
import protocol Catena.Fields

public protocol UserFields: Fields where Model == User.Identified {}
