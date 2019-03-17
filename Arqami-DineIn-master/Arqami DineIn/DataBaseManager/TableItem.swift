//
//  TableItems.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 9/26/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import Foundation
import RealmSwift

class TableItem: Object {
    dynamic var primaryKey = 0
    dynamic var tableId = ""
    dynamic var itemPK = ""
    dynamic var itemId = ""
    dynamic var itemUOMId = ""
    dynamic var itemName = ""
    dynamic var itemQuantity = 0
    dynamic var itemPrice = 0.0
    dynamic var itemTotal = 0.0
    dynamic var RemPrice = 0.0
    dynamic var TaxValue = 0.0
    dynamic var IncludeTax = 0
    var itemAddOns = List<ItemAddOns>()
}
