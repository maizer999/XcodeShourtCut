//
//  DataBaseManager.swift
//  realmPro
//
//  Created by Waleed Jebreen on 11/23/16.
//  Copyright © 2016 Mozaic Innovative Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseManager {
    static let realm = try! Realm()
    
    static func updateTable(data: Table){
        try! realm.write {
            let allObjects = realm.objects(Table.self)
            if allObjects.count > 0{
                let filter = allObjects.filter("tableId == '\(data.tableId)'")
                for object in allObjects{
                    if(object.tableId == data.tableId){
                        object.tableName = data.tableName
                        object.tableItems = data.tableItems
                        realm.add(object)
                    }
                    else if(filter.count == 0){
                        var table = Table()
                        table = data
                        realm.add(table)
                    }
                }
            }else{
                var table = Table()
                table = data
                realm.add(table)
            }
        }
    }

    static func addItemToTable(tableItem: TableItem, tableId: String){
        try! realm.write {
            let allObjects = realm.objects(Table.self)
            let filter = allObjects.filter("tableId == '\(tableId)'")
            if filter.count > 0{
                filter[0].tableItems.append(tableItem)
            }
        }
    }
    
    static func addDeletedItemToTable(tableItem: DeletedTableItem, tableId: String){
        try! realm.write {
            let allObjects = realm.objects(Table.self)
            let filter = allObjects.filter("tableId == '\(tableId)'")
            if filter.count > 0{
                filter[0].deletedTableItems.append(tableItem)
            }
        }
    }
    
//    static func updatItemToTable(tableItem: DeletedTableItem, tableId: String){
//
//    let workouts = realm.objects(WorkoutsCount.self).filter("date = %@", removeTodaysItem)
//
//    let realm = try! Realm()
//    if let workout = workouts.first {
//        try! realm.write {
//            workout.date = today
//            workout.count = plusOne
//        }
//        }
//
//    }
    
    static func updateItemBy(primaryKey: Int , quintity : Int){
        let allObjects = realm.objects(TableItem.self)
        let filter = allObjects.filter("primaryKey == \(primaryKey)")
        if let workout = filter.first {
            try! realm.write {
                workout.itemQuantity = quintity
                workout.itemTotal  = Double( workout.itemQuantity) * workout.itemPrice
                            }
                    }
        }
    
    
    static func addTable(table: Table){
        try! realm.write {
            realm.add(table)
        }
    }
    
    static func getTableBy(tableId: String) -> Table?{
        let allObjects = realm.objects(Table.self)
        let filter = allObjects.filter("tableId == '\(tableId)'")
        if filter.count > 0{
            return filter[0]
        }else{
            return nil
        }
    }
    
    static func getTableItemsCount(tableId: String) -> Int{
        let allObjects = realm.objects(Table.self)
        let filter = allObjects.filter("tableId == '\(tableId)'")
        if filter.count > 0{
            let table = filter[0]
            return table.tableItems.count
        }else{
            return 0
        }
    }
    
    static func getDeletedTableItemsCount(tableId: String) -> Int{
        let allObjects = realm.objects(Table.self)
        let filter = allObjects.filter("tableId == '\(tableId)'")
        if filter.count > 0{
            let table = filter[0]
            return table.deletedTableItems.count
        }else{
            return 0
        }
    }
    
    static func getTableItemBy(tableId: String,itemId: String) -> TableItem?{
        let allItemObjects = realm.objects(TableItem.self)
        let allTableObjects = realm.objects(Table.self)
        let itemsFilter = allItemObjects.filter("itemId == '\(itemId)'")
        let tablesFilter = allTableObjects.filter("tableId == '\(tableId)'")
        if tablesFilter.count > 0{
            if itemsFilter.count > 0{
                let item = itemsFilter[0]
                return item
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    static func getAllTableItems(tableId: String) -> [TableItem]{
        let allObjects = realm.objects(Table.self)
        let filter = allObjects.filter("tableId == '\(tableId)'")
        var items = [TableItem]()
        if filter.count > 0{
            let table = filter[0]
            for item in table.tableItems{
                items.append(item)
            }
        }
        return items
    }
    
    static func getAllDeletedTableItems(tableId: String) -> [DeletedTableItem]{
        let allObjects = realm.objects(Table.self)
        let filter = allObjects.filter("tableId == '\(tableId)'")
        var items = [DeletedTableItem]()
        if filter.count > 0{
            let table = filter[0]
            for item in table.deletedTableItems{
                items.append(item)
            }
        }
        return items
    }
    
    static func deleteItemBy(primaryKey: Int){
        let allObjects = realm.objects(TableItem.self)
        let filter = allObjects.filter("primaryKey == \(primaryKey)")
        if filter.count > 0{
            let item = filter[0]
            try! realm.write {
                realm.delete(item)
            }
        }
    }
    

    
    static func getItemsMaxPrimaryKey() -> Int{
        let allObjects = realm.objects(TableItem.self)
        var maxPrimary = 0
        for object in allObjects{
            if object.primaryKey > maxPrimary{
                maxPrimary = object.primaryKey
            }
        }
        return maxPrimary
    }

    static func getDeletedItemsMaxPrimaryKey() -> Int{
        let allObjects = realm.objects(DeletedTableItem.self)
        var maxPrimary = 0
        for object in allObjects{
            if object.primaryKey > maxPrimary{
                maxPrimary = object.primaryKey
            }
        }
        return maxPrimary
    }
    
    static func deleteAllTableItems(tableId: String){
        let allObjects = realm.objects(Table.self)
        let filter = allObjects.filter("tableId == '\(tableId)'")
        if filter.count > 0{
            try! realm.write {
                let items = filter[0].tableItems
                for item in items{
                    realm.delete(item.itemAddOns)
                }
                realm.delete(items)
            }
        }
    }
    
    static func deleteAllDeletedTableItems(tableId: String){
        let allObjects = realm.objects(Table.self)
        let filter = allObjects.filter("tableId == '\(tableId)'")
        if filter.count > 0{
            try! realm.write {
                let items = filter[0].deletedTableItems
                realm.delete(items)
            }
        }
    }

//    func get(key: String) -> NSDictionary?{
//        let allObjects = DataBaseManager.realm.objects(Cash.self)
//        if allObjects.count > 0{
//            for object in allObjects{
//                if(object.key == key){
//                    return convertToDictionary(text: object.value)
//                }
//            }
//        }
//        return NSDictionary()
//    }
    
    func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                return dataDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return NSDictionary()
    }
    static func getFileURL() -> URL{
        return Realm.Configuration.defaultConfiguration.fileURL!
    }

    
//    static func updateOrder(data: OrderedItems){
//        try! realm.write {
//            let allObjects = realm.objects(OrderedItems.self)
//            if allObjects.count > 0{
//                let filter = allObjects.filter("primaryKeys == \(data.primaryKeys)")
//                for object in allObjects{
//                    if(object.primaryKeys == data.primaryKeys){
//                        object.id = data.id
//                        object.name = data.name
//                        object.price = data.price
//                        object.priceUnit = data.priceUnit
//                        object.quantity = data.quantity
//                        object.url = data.url
//                        object.priceId = data.priceId
//                        object.totalPrice = data.totalPrice
//                        object.itemOptions = data.itemOptions
//                        object.instructions = data.instructions
//                        object.brandId = data.brandId
//                        object.brandName = data.brandName
//                        realm.add(object)
//                    }
//                    else if(filter.count == 0){
//                        var order = OrderedItems()
//                        order = data
//                        realm.add(order)
//                    }
//                }
//            }else{
//                var order = OrderedItems()
//                order = data
//                realm.add(order)
//            }
//        }
//    }
//    static func getMaxPrimaryKey() -> Int{
//        let allObjects = realm.objects(OrderedItems.self)
//        var maxPrimary = 0
//        for object in allObjects{
//            if object.primaryKeys > maxPrimary{
//                maxPrimary = object.primaryKeys
//            }
//        }
//        return maxPrimary
//    }
}
