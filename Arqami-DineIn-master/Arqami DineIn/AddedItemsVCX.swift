//
//  AddedItemsVCX.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 10/15/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit
import RealmSwift

class AddedItemsVCX: UIViewController {

    var selectedTable = TablesModel()
    
    var orderModel = [OrderModel](){
        didSet{
            if !orderModel.isEmpty{
                
                var allOrderItems = [OrderItems]()
                for order in orderModel{
                    if let orderId = order.orderID{
                        self.existedOrderId = orderId
                    }else{
                        self.existedOrderId = ""
                    }
                    
                    if let orderItems = order.orderItems{
                        allOrderItems += orderItems
                    }
                }
                self.orderItems = allOrderItems
            }else{
                existedOrderId = ""
            }
        }
    }
    
    var orderItems = [OrderItems](){
        didSet{
            if !orderItems.isEmpty{
                self.navDeleteOrderBtn.isHidden = false
                self.noItemsLabel.isHidden = true
             
                updateTotalAmount()
                //   var orderTotal = 0.0
//                var itemSubTotal = 0.0
//                for item in orderItems
//                {
//                    if let itemTotal = item.itemTotal{
//                        orderTotal += itemTotal
//                        itemSubTotal += itemTotal
//                        if ( item.IncludeTax == 0) {
//                            orderTotal += item.ItemTax!
//
//                        }
//
//                    }
//
//                   subTotalLabel.text = "\(itemSubTotal)"
//                    totalLabel.text = "\(orderTotal)"
//                }
            }else{
                self.navDeleteOrderBtn.isHidden = true
                self.noItemsLabel.isHidden = false
                totalLabel.text = String("0.0")
                totalTaxLabel.text = String("0.0")
                subTotalLabel.text = String("0.0")
            }
            self.orderedItemsTableView.reloadData()
        }
    }
    
    func updateTotalAmount(){
        var orderTotalBeforeTax = 0.0
        var orderTotalAfterTax = 0.0
        var itemSubTotal = 0.0
        
        for item in orderItems
        {
            if let itemTotal = item.itemTotal{
                itemSubTotal += Double(item.itemQty!) * item.itemPrice!

                
                if ( item.IncludeTax == 0) {
                    
                    orderTotalBeforeTax += Double(item.itemQty!) * item.itemPrice!
                    orderTotalAfterTax += Double(item.itemQty!) * item.itemPrice! * 1.05
                    
                    
                    
             
                } else{
                     orderTotalBeforeTax += Double(item.itemQty!) * item.itemPrice!/1.05
                    orderTotalAfterTax += Double(item.itemQty!) * item.itemPrice!
                    
               
                }
            }
            subTotalLabel.text = "\(orderTotalBeforeTax.truncate(places: 2))"
            totalLabel.text = "\(orderTotalAfterTax.truncate(places: 2))"
            totalTaxLabel.text = "\((orderTotalAfterTax - orderTotalBeforeTax).truncate(places: 2))"
        }
        
    }
    
   
    
    var existedOrderId = ""
    
    var dataBaseNotificationToken: NotificationToken?

    @IBOutlet weak var totalTaxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var orderedItemsTableView: UITableView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var calculationsView: UIViewX!
    @IBOutlet weak var noItemsLabel: UILabel!
    
    @IBOutlet weak var navDeleteOrderBtn: UIButton!
    @IBOutlet weak var deletedItemsView: UIView!
    @IBOutlet weak var deletedItemsTableView: UITableView!
    @IBOutlet weak var deleteItemsButton: UIButtonX!
    @IBOutlet weak var cancelButton: UIButtonX!
    
    var deletedTableItems = [DeletedTableItem](){
        didSet{
            deletedItemsTableView.reloadData()
        }
    }
    
    let cantDeleteOrderItem = Constants.LocalizedStrings.cantDeleteOrderItem
    let appName = Constants.LocalizedStrings.appName
    let ok = Constants.LocalizedStrings.okbtn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("FILEURL:- \(DataBaseManager.getFileURL())")
        
        getDataBaseNotification()

        self.orderedItemsTableView.rowHeight = UITableViewAutomaticDimension
        self.orderedItemsTableView.estimatedRowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getOrderedItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let tableId = self.selectedTable.iD{
            DataBaseManager.deleteAllDeletedTableItems(tableId: tableId)
        }
    }
    //MARK:- Get Order Items
    func getOrderedItems(){
        //self.loadingSpinner.startAnimating()
        let language = Defaults.getLanguage()
        let storeId = Defaults.getStoreId()!
        let httpManager = HttpRestManager()
        if let tableId = selectedTable.iD{
            
            print("\(Defaults.getBaseURL()!+"api/DN/POSGetTableOrder_m?TableID=\(tableId)&LangID=\(language)&StoreID=\(storeId)")")
            
            
            httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSGetTableOrder_m?TableID=\(tableId)&LangID=\(language)&StoreID=\(storeId)", connectionType: .None, resultHandler: { (stringData) in
                DispatchQueue.main.async {
                    let result = httpManager.convertToDictionary(text: stringData)
                    let orderedItemsMapper = OrderedItemsMapper(dictionary: result!)
                    print("maizer  \(result)")
                    if let isSucceeded = orderedItemsMapper?.isSucceeded{
                        if isSucceeded{
                            if let orderModel = orderedItemsMapper?.orderModel{
                                
                                //@maizer update 
                              
                                
                                self.subTotalLabel.text =   String(orderModel[0].SubTotal!)
                                self.totalTaxLabel.text =   String(orderModel[0].TaxTotal!)
                                self.totalLabel.text =   String(orderModel[0].total!)
                                
                                self.orderModel = orderModel
                            }
                        }
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    //self.loadingSpinner.stopAnimating()
                    if error == ErrorType.NotConnected{
                        UIHelper.alertForNotConnected()
                    }else{
                        self.present(UIHelper.alertForError(), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    //MARK:- Get Data Base Notifications
    func getDataBaseNotification(){
        let realm = try! Realm()
        dataBaseNotificationToken = realm.addNotificationBlock { note, realm in
            if let tableId = self.selectedTable.iD{
                let numberOfDeletedItems = DataBaseManager.getDeletedTableItemsCount(tableId: tableId)

                if numberOfDeletedItems == 0{
                    self.calculationsView.isHidden = false
                    self.deletedItemsView.isHidden = true
                }else{
                    let deletedItems = DataBaseManager.getAllDeletedTableItems(tableId: tableId)
                    self.deletedTableItems = deletedItems
                    self.calculationsView.isHidden = true
                    self.deletedItemsView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func increaseItem(_ sender: UIButton) {
        
        orderItems[sender.tag].itemQty = orderItems[sender.tag].itemQty! + 1
        orderedItemsTableView.reloadData()
         updateTotalAmount()
    }
    
    @IBAction func decreaseItem(_ sender: UIButton) {
        
        if orderItems[sender.tag].itemQty! > 1 {
            
             let tableItem = DeletedTableItem()
            tableItem.itemId = orderItems[sender.tag].itemID!
            tableItem.itemPK = orderItems[sender.tag].orderItemPK!
            deletedTableItems.append(tableItem)
            orderItems[sender.tag].itemQty = orderItems[sender.tag].itemQty! - 1
            orderedItemsTableView.reloadData()
             updateTotalAmount()
        }
    
    }
    
    
    @IBAction func cancelAction() {
        if let tableId = selectedTable.iD{
            DataBaseManager.deleteAllDeletedTableItems(tableId: tableId)
        }
        
        self.getOrderedItems()
    }
    
    @IBAction func deleteOrderAction() {
        self.view.endEditing(true)
        let itemsDictionary = NSMutableDictionary()
        //print("\(SecurityManager.getAuthenticationToken(connectionType: .SessionToken))")
        
        if Defaults.getCanDeleteOrderItem(){
            
            itemsDictionary["OrderID"] = self.existedOrderId
            itemsDictionary["WaiterID"] = ""
            itemsDictionary["CustID"] = ""
            itemsDictionary["UserID"] = Defaults.getUserID()!
            itemsDictionary["TableID"] = selectedTable.iD!
            itemsDictionary["StoreID"] = Defaults.getStoreId()!
            itemsDictionary["DOBID"] = Defaults.getDOBID()!
            itemsDictionary["Remarks"] = ""
            itemsDictionary["LangID"] = Defaults.getLanguage()
            itemsDictionary["CustName"] = ""
            itemsDictionary["ItemRemarkswithIDs"] = ""
            itemsDictionary["Mobile"] = ""
            itemsDictionary["DeleteOrder"] = true
            
            let itemPricesSummation = 0.0
            itemsDictionary["Total"] = itemPricesSummation
            
            itemsDictionary["OccSeats"] = 0
            itemsDictionary["Par1"] = ""
            itemsDictionary["Par2"] = ""
            itemsDictionary["Par3"] = ""
            itemsDictionary["Par4"] = ""
            
            let orderModel = [NSDictionary]()
            itemsDictionary["OrderItems"] = orderModel
            
            let deletedItems = [NSDictionary]()
            itemsDictionary["DeletedItems"] = deletedItems
            
            let alertController = UIHelper.makeAlertController(alertTitle: Constants.LocalizedStrings.appName, alertMessage: Constants.LocalizedStrings.sureSendOrder, okString: Constants.LocalizedStrings.okbtn, cancelString: Constants.LocalizedStrings.cancel, needCancel: true, okActionHandler: {
                self.deleteItems(itemsDictionary)
         
            }, cancelActionHandler: {})
            
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            cantDeleteAlert()
        }
    }
    
    //MARK:- Can't Delete Alert
    func cantDeleteAlert(){
        let alertController = UIHelper.makeAlertController(alertTitle: self.appName, alertMessage: self.cantDeleteOrderItem, okString: self.ok, okActionHandler: {}, cancelActionHandler: {})
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    // @maizer send 
    
    @IBAction func sendOrderAction() {
        
        
        self.view.endEditing(true)
        let itemsDictionary = NSMutableDictionary()
        //print("\(SecurityManager.getAuthenticationToken(connectionType: .SessionToken))")
        
        if Defaults.getCanSaveOrder(){
            
            itemsDictionary["OrderID"] = self.existedOrderId
            itemsDictionary["WaiterID"] = ""
            itemsDictionary["CustID"] = ""
            itemsDictionary["UserID"] = Defaults.getUserID()!
            itemsDictionary["TableID"] = selectedTable.iD!
            itemsDictionary["StoreID"] = Defaults.getStoreId()!
            itemsDictionary["DOBID"] = Defaults.getDOBID()!
            itemsDictionary["Remarks"] = ""
            itemsDictionary["LangID"] = Defaults.getLanguage()
            itemsDictionary["CustName"] = ""
            itemsDictionary["ItemRemarkswithIDs"] = ""
            itemsDictionary["Mobile"] = ""
            itemsDictionary["DeleteOrder"] = false
            
            let deletedItems = [NSDictionary]()
            
            itemsDictionary["DeletedItems"] = deletedItems
            
            var itemPricesSummation = 0.0
            var tax = 0.0
            var total = 0.0
//
//            for item in addedItems{
//                itemPricesSummation += item.itemTotal
//
//                if (item.IncludeTax == 1) {
//
//                    tax =  tax + item.itemTotal - (item.itemTotal / ( 1 + ( item.TaxValue / 100 )) )
//                    total = total + item.itemTotal
//
//                } else {
//
//                    tax = tax + ((item.itemTotal * ( 1 + ( item.TaxValue / 100 )) ) - item.itemTotal )
//                    total = total + item.itemTotal
//
//                }
//            }
//
            total = total + tax
            
            
            
            
            
            itemsDictionary["Total"] = total
            
            itemsDictionary["OccSeats"] = 0
            
            itemsDictionary["Par1"] = ""
            itemsDictionary["Par2"] = ""
            itemsDictionary["Par3"] = ""
            itemsDictionary["Par4"] = ""
            
            if(orderItems.count != 0){
                var orderModel = [NSDictionary]()
                for item in orderItems{
                
                    var addOnsArray = [NSDictionary]()
//                    for addOn in item{
//                        let itemAddOn = NSMutableDictionary()
//                        let addOnName = addOn.addOnName
//                        itemAddOn["ItemRemark"] = addOnName
//
//                        addOnsArray.append(itemAddOn)
//                    }
                    
                    let itemObject = NSMutableDictionary()
                    let itemId = item.itemID
                    let itemUOMID = item.itemUOMID
                    let quantity = item.itemQty
                    let itemPrice = item.itemPrice
                    var itemTotal = item.itemTotal
                    var itemTax = item.ItemTax
                    let OrderItemPK = item.orderItemPK
                    if (item.IncludeTax == 1) {
                        
                        itemTax = item.itemTotal! - (item.itemTotal! / ( 1 + ( item.ItemTax! / 100 )) )
                        itemTotal = item.itemTotal
                        
                    } else {
                        itemTax = (item.itemTotal! * ( 1 + ( item.ItemTax! / 100 )) ) - item.itemTotal!
                        itemTotal = Double(item.itemTotal!) + itemTax!
                    }
                    
                    //@ maizer
                    
                    
                    
                    
                    
                    itemObject["ItemRemarks"] = addOnsArray
                    itemObject["itemID"] = itemId
                    itemObject["ItemUOMID"] = itemUOMID
                    itemObject["OrderItemPK"] = OrderItemPK
                    itemObject["ItemQty"] = quantity
                    itemObject["ItemPrice"] = itemPrice
                    itemObject["ItemTotal"] = Double(quantity!) * itemPrice!
//                    itemObject["RemPrice"] = item.RemPrice * Double(quantity)
                    itemObject["RemPrice"] = 0
  
                    itemObject["ItemTax"] = itemTax?.truncate(places: 2)
                    
                    orderModel.append(itemObject)
                }
                
                itemsDictionary["OrderItems"] = orderModel
                let alertController = UIHelper.makeAlertController(alertTitle: Constants.LocalizedStrings.appName, alertMessage: Constants.LocalizedStrings.sureSendOrder, okString: Constants.LocalizedStrings.okbtn, cancelString: Constants.LocalizedStrings.cancel, needCancel: true, okActionHandler: {
                self.sendOrder(itemsDictionary)
    
                }, cancelActionHandler: {})
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        }else{
            let alertController = UIHelper.makeAlertController(alertTitle: self.appName, alertMessage: self.cantSaveOrder, okString: self.ok, okActionHandler: {}, cancelActionHandler: {})
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
     let cantSaveOrder = Constants.LocalizedStrings.cantSaveOrder
    
    
    
    //MARK:- Send Order
    func sendOrder(_ dataDictionary: NSDictionary){
        let httpManager = HttpRestManager()
        
        
        
        if let json = httpManager.convertDictionaryToJSON(dictionary: dataDictionary){
            print("\(json)")
        }
        self.loadingSpinner.startAnimating()
//        self.sendOrderButton.isUserInteractionEnabled = false
//        self.sendOrderButton.alpha = 0.5
        
        
        httpManager.post(url: Defaults.getBaseURL()!+"api/DN/POSSaveOrder__m", connectionType: .None, dataToPost: dataDictionary, resultHandler: {stringData in
            DispatchQueue.main.async {
                
                
                let result = httpManager.convertToDictionary(text: stringData)
                print("dataDictionary    \(dataDictionary)")
                print("result    \(result)")
                if let isSucceeded = result?["status"] as? Bool{
                    if isSucceeded{
                            self.loadingSpinner.stopAnimating()
                        
//                        self.sendOrderButton.isUserInteractionEnabled = true
//                        self.sendOrderButton.alpha = 1
//
                        if let tableId = self.selectedTable.iD{
                            DataBaseManager.deleteAllTableItems(tableId: tableId)
                            self.getOrderedItems()
                        }
                    }else{
                        self.present(UIHelper.alertForError(), animated: true, completion: nil)
                        self.loadingSpinner.stopAnimating()
//                        self.sendOrderButton.isUserInteractionEnabled = true
//                        self.sendOrderButton.alpha = 1
                    }
                }
            }
        }, errorHandler: {error in
            DispatchQueue.main.async {
                //print("\(error)")
                if error == ErrorType.NotConnected{
                    UIHelper.alertForNotConnected()
                }else{
                    self.present(UIHelper.alertForError(), animated: true, completion: nil)
                }
                self.loadingSpinner.stopAnimating()
//                self.sendOrderButton.isUserInteractionEnabled = true
//                self.sendOrderButton.alpha = 1
            }
        })
    }
    
    
    //MARK:- Delete Items Actions
    @IBAction func deleteItemsAction() {
        self.view.endEditing(true)
        let itemsDictionary = NSMutableDictionary()
        //print("\(SecurityManager.getAuthenticationToken(connectionType: .SessionToken))")
        
        if Defaults.getCanDeleteOrderItem(){
            
            itemsDictionary["OrderID"] = self.existedOrderId
            itemsDictionary["WaiterID"] = ""
            itemsDictionary["CustID"] = ""
            itemsDictionary["UserID"] = Defaults.getUserID()!
            itemsDictionary["TableID"] = selectedTable.iD!
            itemsDictionary["StoreID"] = Defaults.getStoreId()!
            itemsDictionary["DOBID"] = Defaults.getDOBID()!
            itemsDictionary["Remarks"] = ""
            itemsDictionary["LangID"] = Defaults.getLanguage()
            itemsDictionary["CustName"] = ""
            itemsDictionary["ItemRemarkswithIDs"] = ""
            itemsDictionary["Mobile"] = ""
            itemsDictionary["DeleteOrder"] = false
            
            let itemPricesSummation = 0.0
            itemsDictionary["Total"] = itemPricesSummation
            
            itemsDictionary["OccSeats"] = 0
            itemsDictionary["Par1"] = "0"
            itemsDictionary["Par2"] = ""
            itemsDictionary["Par3"] = ""
            itemsDictionary["Par4"] = ""
            
            let orderModel = [NSDictionary]()
            itemsDictionary["OrderItems"] = orderModel
            
            var deletedItems = [NSDictionary]()
            for item in deletedTableItems{
                let itemObject = NSMutableDictionary()
                itemObject["DeletedItem"] = item.itemPK
                deletedItems.append(itemObject)
            }
            itemsDictionary["DeletedItems"] = deletedItems
        
            
            let alertController = UIHelper.makeAlertController(alertTitle: Constants.LocalizedStrings.appName, alertMessage: Constants.LocalizedStrings.sureSendOrder, okString: Constants.LocalizedStrings.okbtn, cancelString: Constants.LocalizedStrings.cancel, needCancel: true, okActionHandler: {
                self.deleteItems(itemsDictionary)
           
            }, cancelActionHandler: {})
            
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            cantDeleteAlert()
        }
    }

    //MARK:- Send Order
    func deleteItems(_ dataDictionary: NSDictionary){
        let httpManager = HttpRestManager()
        
//        if let json = httpManager.convertDictionaryToJSON(dictionary: dataDictionary){
//            print("\(json)")
//        }
        print("dataDictionary    :  \(dataDictionary)")
        self.loadingSpinner.startAnimating()
        self.deleteItemsButton.isUserInteractionEnabled = false
        self.deleteItemsButton.alpha = 0.5
  
        httpManager.post(url: Defaults.getBaseURL()!+"api/DN/POSSaveOrder__m", connectionType: .None, dataToPost: dataDictionary, resultHandler: {stringData in
            DispatchQueue.main.async {
                let result = httpManager.convertToDictionary(text: stringData)
                if let isSucceeded = result?["status"] as? Bool{
                    if isSucceeded{
                        if let tableId = self.selectedTable.iD{
                            DataBaseManager.deleteAllDeletedTableItems(tableId: tableId)
                        }
                        
                        self.orderItems = [OrderItems]()
                        
                        self.getOrderedItems()
                        
                        self.loadingSpinner.stopAnimating()
                        self.deleteItemsButton.isUserInteractionEnabled = true
                        self.deleteItemsButton.alpha = 1
                        
                    }else{
                        self.present(UIHelper.alertForError(), animated: true, completion: nil)
                        self.loadingSpinner.stopAnimating()
                        self.deleteItemsButton.isUserInteractionEnabled = true
                        self.deleteItemsButton.alpha = 1
                    }
                }
            }
        }, errorHandler: {error in
            DispatchQueue.main.async {
                //print("\(error)")
                if error == ErrorType.NotConnected{
                    UIHelper.alertForNotConnected()
                }else{
                    self.present(UIHelper.alertForError(), animated: true, completion: nil)
                }
                self.loadingSpinner.stopAnimating()
                self.deleteItemsButton.isUserInteractionEnabled = true
                self.deleteItemsButton.alpha = 1
            }
        })
    }
}

extension AddedItemsVCX: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderedItemsTableView{
            return orderItems.count
        }else{
            return deletedTableItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == orderedItemsTableView{
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                let itemToDelete = orderItems[indexPath.row]
                addDeletedOrderItem(itemToDelete: itemToDelete)
                orderItems.remove(at: indexPath.row)
            }
        }
    }
    
    func addDeletedOrderItem(itemToDelete: OrderItems){
        let tableItem = DeletedTableItem()
        if let tableId = selectedTable.iD{
            if let itemPrice = itemToDelete.itemPrice{
                if let itemUOMId = itemToDelete.itemUOMID{
                    if let itemId = itemToDelete.itemID{
                        if let itemName = itemToDelete.itemName{
                            if let quantity = itemToDelete.itemQty{
                                if let totalPrice = itemToDelete.itemTotal{
                                    if let addOnsString = itemToDelete.itemRemark{
                                        if let itemPK = itemToDelete.orderItemPK{
                                            tableItem.primaryKey = DataBaseManager.getDeletedItemsMaxPrimaryKey() + 1
                                            tableItem.tableId = tableId
                                            tableItem.itemId = itemId
                                            tableItem.itemPrice = Double(itemPrice)
                                            tableItem.itemUOMId = itemUOMId
                                            tableItem.itemName = itemName
                                            tableItem.itemQuantity = quantity
                                            
                                            tableItem.itemTotal = totalPrice
                                            tableItem.itemAddOns = addOnsString
                                            tableItem.itemPK = itemPK
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if let tableId = selectedTable.iD{
            if let tableName = selectedTable.name{
                if let _ = DataBaseManager.getTableBy(tableId: tableId){
                    DataBaseManager.addDeletedItemToTable(tableItem: tableItem, tableId: tableId)
                }else{
                    let table = Table()
                    table.tableId = tableId
                    table.tableName = tableName
                    DataBaseManager.addTable(table: table)
                    DataBaseManager.addDeletedItemToTable(tableItem: tableItem, tableId: tableId)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == orderedItemsTableView{
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderedItemsTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderedItemsCell") as! OrderedItemsCell
            
            cell.increaseButton.tag = indexPath.row
            cell.decreaseButton.tag = indexPath.row
            if let itemName = orderItems[indexPath.row].itemName{
                cell.itemNameLabel.text = itemName
            }
            if let itemTotal = orderItems[indexPath.row].itemTotal{
                var total = 0.0
                total = itemTotal
                cell.totalPriceLabel.text = "\(total)"
            }
 
            if let itemQuantity = orderItems[indexPath.row].itemQty{
                cell.quantityLabel.text = "\(itemQuantity)"
                var total = 0.0
                total = Double(itemQuantity) * orderItems[indexPath.row].itemPrice!
                   cell.totalPriceLabel.text = "\(total)"
                
            }
            
            if let itemRemark = orderItems[indexPath.row].itemRemark{
                if itemRemark != ""{
                    cell.itemAddOnsLabel.text = "\n \(itemRemark) \n"
                }else{
                    cell.itemAddOnsLabel.text = "\n \(Constants.LocalizedStrings.noAddOnsAvailable) \n"
                }
            }else{
                cell.itemAddOnsLabel.text = "\n \(Constants.LocalizedStrings.noAddOnsAvailable) \n"
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeletedItemCell") as! DeletedItemCell
            
            cell.itemNameLabel.text = deletedTableItems[indexPath.row].itemName
            cell.totalPriceLabel.text = "\(deletedTableItems[indexPath.row].itemTotal)"
            
            return cell
        }
    }
}
