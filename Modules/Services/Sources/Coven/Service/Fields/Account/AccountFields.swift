// Copyright © Fleuronic LLC. All rights reserved.

import Catena

import struct Coven.Account

protocol AccountFields: Fields where Model == Account.Identified {}
