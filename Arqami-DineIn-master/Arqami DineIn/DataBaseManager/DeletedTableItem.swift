//
//  DeletedTableItem.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 10/8/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import Foundation
import RealmSwift

class DeletedTableItem: Object {
    
    dynamic var primaryKey = 0
    dynamic var tableId = ""
    dynamic var itemPK = ""
    dynamic var itemId = ""
    dynamic var itemUOMId = ""
    dynamic var itemName = ""
    dynamic var itemQuantity = 0
    dynamic var itemPrice = 0.0
    dynamic var itemTotal = 0.0
    dynamic var itemAddOns = ""
}
