//
//  Table.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 9/26/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import Foundation
import RealmSwift

class Table: Object {
    dynamic var tableId = ""
    dynamic var tableName = ""
    var tableItems = List<TableItem>()
    var deletedTableItems = List<DeletedTableItem>()
}
