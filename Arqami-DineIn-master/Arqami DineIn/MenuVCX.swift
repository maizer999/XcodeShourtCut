//
//  MenuVCX.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 10/15/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import RealmSwift

class MenuVCX: UIViewController, UIPopoverPresentationControllerDelegate  {

    var selectedTable = TablesModel()
    
    var categoriesModel = [GroupsModel]()
    var selectedCategory = GroupsModel(){
        didSet{
            if let id = selectedCategory.iD{
                getCategoryItems(id: id)
            }
        }
    }
    
    var itemsModel = [ItemsModel](){
        didSet{
            self.itemsTableView.reloadData()
        }
    }
    
    let badge = MIBadgeButton()
    
    var tableBadgeNumber = 0{
        didSet{
            if(tableBadgeNumber != 0){
                badge.badgeString = "\(tableBadgeNumber)"
                navTable.addSubview(badge)
            }else{
                badge.badgeString = ""
                navTable.addSubview(badge)
            }
        }
    }
    
    var orderModel = [OrderModel](){
        didSet{
            if !orderModel.isEmpty{
                
                var allOrderItems = [OrderItems]()
                for order in orderModel{
                    if let orderId = order.orderID{
                        self.existedOrderId = orderId
                    }
                    
                    if let orderItems = order.orderItems{
                        allOrderItems += orderItems
                    }
                }
                self.orderItems = allOrderItems
            }else{
                orderItems = [OrderItems]()
                existedOrderId = ""
            }
        }
    }
    var existedOrderId = ""
    
    var orderItems = [OrderItems](){
        didSet{
            let numberOfOrderedItems = orderItems.count
            self.tableBadgeNumber = numberOfOrderedItems
            if(numberOfOrderedItems == 0){
                self.navTable.isHidden = true
            }else{
                self.navTable.isHidden = false
            }
        }
    }
    
    var addedItems = [TableItem](){
        didSet{
            if addedItems.isEmpty{
                self.noOrderedItemsLabel.isHidden = false
                totalTaxAddedOrderView.isHidden = true
                totalAddedOrderView.isHidden = true
                subtotalAddedOrderView.isHidden = true
                sendOrderButton.isHidden = true
            }else{
                
                self.noOrderedItemsLabel.isHidden = true
                totalTaxAddedOrderView.isHidden = false
                totalAddedOrderView.isHidden = false
                sendOrderButton.isHidden = false
                subtotalAddedOrderView.isHidden = false
                updateCalculations()
            }
            addedItemsTableView.reloadData()
        }
    }

    var dataBaseNotificationToken: NotificationToken?
    @IBOutlet weak var navTable: UIButton!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var addedItemsTableView: UITableView!
    @IBOutlet weak var noOrderedItemsLabel: UILabel!
    @IBOutlet weak var totalAddedOrderView: UIViewX!
    @IBOutlet weak var totalAddedOrderLabel: UILabel!
    @IBOutlet weak var totalTaxAddedOrderView: UIViewX!
    @IBOutlet weak var totalTaxAddedOrderLabel: UILabel!
    @IBOutlet weak var subtotalAddedOrderView: UIViewX!
    @IBOutlet weak var subtotalAddedOrderLabel: UILabel!
    
    
    @IBOutlet weak var sendOrderButton: UIButtonX!
    @IBOutlet weak var categoriesView: UIViewX!
    
    let cantSaveOrder = Constants.LocalizedStrings.cantSaveOrder
    let appName = Constants.LocalizedStrings.appName
    let ok = Constants.LocalizedStrings.okbtn

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addedItemsTableView.rowHeight = UITableViewAutomaticDimension
        self.addedItemsTableView.estimatedRowHeight = 140
        
        if let tableName = selectedTable.name{
            self.navigationItem.title = tableName
        }
        
        getDataBaseNotification()
        if let tableId = selectedTable.iD{
            let numberOfOrderedItems = DataBaseManager.getTableItemsCount(tableId: tableId)
            if(numberOfOrderedItems == 0){
                self.navTable.isHidden = true
            }else{
                self.navTable.isHidden = false
            }
        }
        
        getCategories()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getOrderedItems()
        getDataFromDataBase()
    }
    
    func getOrderedItems(){
        //self.loadingSpinner.startAnimating()
        let language = Defaults.getLanguage()
        let storeId = Defaults.getStoreId()!
        let httpManager = HttpRestManager()
        if let tableId = selectedTable.iD{
            httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSGetTableOrder_m?TableID=\(tableId)&LangID=\(language)&StoreID=\(storeId)", connectionType: .None, resultHandler: { (stringData) in
                DispatchQueue.main.async {
                    let result = httpManager.convertToDictionary(text: stringData)
                    let orderedItemsMapper = OrderedItemsMapper(dictionary: result!)
                    if let isSucceeded = orderedItemsMapper?.isSucceeded{
                        if isSucceeded{
                            //self.loadingSpinner.stopAnimating()
                            if let orderModel = orderedItemsMapper?.orderModel{
                                self.orderModel = orderModel
                            }
                        }else{
                           self.orderModel = [OrderModel]()
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
    //MARK:- Update Calculations
    func updateCalculations(){
        var totalbeforeTax = 0.0
        var totalAfterTax = 0.0
        for item in addedItems{
            if(item.IncludeTax == 1) {
            Defaults.setIncludeTax(includeTax: 1)
            totalbeforeTax =  totalbeforeTax + (item.itemTotal / ( 1 + ( item.TaxValue / 100 )) )
            totalAfterTax = totalAfterTax + ( item.itemTotal  )
            } else {
            Defaults.setIncludeTax(includeTax: 0)
            totalbeforeTax =  totalbeforeTax + ( item.itemTotal)
            totalAfterTax =   totalAfterTax + (item.itemTotal * ( 1 + ( item.TaxValue / 100 )) )
            }
            totalbeforeTax = totalbeforeTax.truncate(places: 2)
            totalAfterTax = totalAfterTax.truncate(places: 2)
        }

        let totalTax = (totalAfterTax - totalbeforeTax )
        totalAddedOrderLabel.text = "\(totalAfterTax)"
        subtotalAddedOrderLabel.text =  "\(totalbeforeTax )"
        totalTaxAddedOrderLabel.text = "\(totalTax.truncate(places: 2) )"
    }
    
    //MARK:- Get Data From DataBase
    func getDataBaseNotification(){
        let realm = try! Realm()
        dataBaseNotificationToken = realm.addNotificationBlock { note, realm in
            self.getDataFromDataBase()
        }
    }
    
    func getDataFromDataBase(){
        if let tableId = selectedTable.iD{
            let addedItems = DataBaseManager.getAllTableItems(tableId: tableId)
            self.addedItems = addedItems
        }
    }
    
    @IBAction func navTableAction() {
        performSegue(withIdentifier: "MenuVCToAddedItemsSegue", sender: nil)
    }
    
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

            for item in addedItems{
                itemPricesSummation += item.itemTotal
                
                if (item.IncludeTax == 1) {
                    
                    tax =  tax + item.itemTotal - (item.itemTotal / ( 1 + ( item.TaxValue / 100 )) )
                    total = total + item.itemTotal
                    
                } else {
                    
                    tax = tax + ((item.itemTotal * ( 1 + ( item.TaxValue / 100 )) ) - item.itemTotal )
                    total = total + item.itemTotal
              
                }
            }
            
            total = total + tax
            
            
            
            
            
            itemsDictionary["Total"] = total
            
            itemsDictionary["OccSeats"] = 0
            
            itemsDictionary["Par1"] = ""
            itemsDictionary["Par2"] = ""
            itemsDictionary["Par3"] = ""
            itemsDictionary["Par4"] = ""
            
            if(addedItems.count != 0){
                var orderModel = [NSDictionary]()
                for item in addedItems{
                    var addOnsArray = [NSDictionary]()
                    for addOn in item.itemAddOns{
                        let itemAddOn = NSMutableDictionary()
                        let addOnName = addOn.addOnName
                        itemAddOn["ItemRemark"] = addOnName
                        
                        addOnsArray.append(itemAddOn)
                    }
                    
                    let itemObject = NSMutableDictionary()
                    let itemId = item.itemId
                    let itemUOMID = item.itemUOMId
                    let quantity = item.itemQuantity
                    let itemPrice = item.itemPrice
                    var itemTotal = item.itemTotal
                    var itemTax = item.itemTotal
                    
                    if (item.IncludeTax == 1) {
                        
                        itemTax = item.itemTotal - (item.itemTotal / ( 1 + ( item.TaxValue / 100 )) )
                    itemTotal = item.itemTotal
                        
                    } else {
                        itemTax = (item.itemTotal * ( 1 + ( item.TaxValue / 100 )) ) - item.itemTotal
                        itemTotal = item.itemTotal + itemTax
                    }
                    
                    //@ maizer
                    
                    
                    
                    
                    
                    itemObject["ItemRemarks"] = addOnsArray
                    itemObject["itemID"] = itemId
                    itemObject["ItemUOMID"] = itemUOMID
                    itemObject["ItemQty"] = quantity
                    itemObject["ItemPrice"] = itemPrice
                    itemObject["ItemTotal"] = Double(quantity) * itemPrice
                    itemObject["RemPrice"] = item.RemPrice * Double(quantity)
                    itemObject["ItemTax"] = itemTax.truncate(places: 2)

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
    
    
    //MARK:- Send Order
    func sendOrder(_ dataDictionary: NSDictionary){
        let httpManager = HttpRestManager()
        
        if let json = httpManager.convertDictionaryToJSON(dictionary: dataDictionary){
            print("\(json)")
        }
        self.loadingSpinner.startAnimating()
        self.sendOrderButton.isUserInteractionEnabled = false
        self.sendOrderButton.alpha = 0.5
        
        print("\(Defaults.getBaseURL()!+"api/DN/POSSaveOrder__m")")
        
        httpManager.post(url: Defaults.getBaseURL()!+"api/DN/POSSaveOrder__m", connectionType: .None, dataToPost: dataDictionary, resultHandler: {stringData in
            DispatchQueue.main.async {
                
           
                let result = httpManager.convertToDictionary(text: stringData)
                print("dataDictionary    \(dataDictionary)")
                print("result    \(result)")
                if let isSucceeded = result?["status"] as? Bool{
                    if isSucceeded{
                        
                        self.sendOrderButton.isUserInteractionEnabled = true
                        self.sendOrderButton.alpha = 1
                        
                        if let tableId = self.selectedTable.iD{
                            DataBaseManager.deleteAllTableItems(tableId: tableId)
                            self.addedItems = [TableItem]()
                            self.getOrderedItems()
                        }
                    }else{
                        self.present(UIHelper.alertForError(), animated: true, completion: nil)
                        self.loadingSpinner.stopAnimating()
                        self.sendOrderButton.isUserInteractionEnabled = true
                        self.sendOrderButton.alpha = 1
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
                self.sendOrderButton.isUserInteractionEnabled = true
                self.sendOrderButton.alpha = 1
            }
        })
    }
    
    
    func getCategories(){
        self.loadingSpinner.startAnimating()
        let language = Defaults.getLanguage()
        let httpManager = HttpRestManager()
          print("\(Defaults.getBaseURL()!+"api/DN/POSMenu__m_Mozaic?StoreID=\(Defaults.getStoreId()!)&PageNumber=1&langID=\(language)")")
        httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSMenu__m_Mozaic?StoreID=\(Defaults.getStoreId()!)&PageNumber=1&langID=\(language)", connectionType: .None, resultHandler: { (stringData) in
            DispatchQueue.main.async {
                let result = httpManager.convertToDictionary(text: stringData)
                let categoriesMapper = CategoriesMapper(dictionary: result!)
                if let isSucceeded = categoriesMapper?.isSucceeded{
                    if isSucceeded{
                        self.loadingSpinner.stopAnimating()
                        if let categoriesModel = categoriesMapper?.groupsModel{
                            self.categoriesModel = categoriesModel
                            self.categoriesCollectionView.reloadData()
                            
                            //                            categoriesModel[0].isSelected = true
                            let indexPath = IndexPath(row: 0, section: 0)
                            self.categoriesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                            self.collectionView(self.categoriesCollectionView, didSelectItemAt: indexPath)
                        }
                        if let totalNumberOfResults = categoriesMapper?.totalNumberofResult{
                            if(totalNumberOfResults > Constants.IntConstants.pageCapacity){
                                let totalNumberOfPages = Constants.PagesCounter.getTotalNumberOfPages(totalNumberOfResults)
                                self.getCategoriesToPages(numberOfPages: totalNumberOfPages)
                            }else{
                                self.categoriesCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.loadingSpinner.stopAnimating()
                if error == ErrorType.NotConnected{
                    UIHelper.alertForNotConnected()
                }else{
                    self.present(UIHelper.alertForError(), animated: true, completion: nil)
                }
            }
        }
    }
    
    func getCategoriesToPages(numberOfPages: Int){
        let language = Defaults.getLanguage()
        self.loadingSpinner.startAnimating()
        let httpManager = HttpRestManager()
        
        for page in 2 ... numberOfPages{
            print("\(Defaults.getBaseURL()!+"api/DN/POSMenu__m_Mozaic?StoreID=\(Defaults.getStoreId()!)&PageNumber=\(page)&langID=\(language)")")
            
            httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSMenu__m_Mozaic?StoreID=\(Defaults.getStoreId()!)&PageNumber=\(page)&langID=\(language)", connectionType: .None, resultHandler: {stringData in
                DispatchQueue.main.async {
                    let result = httpManager.convertToDictionary(text: stringData)
                    let categoriesMapper = CategoriesMapper(dictionary: result!)
                    if let isSucceeded = categoriesMapper?.isSucceeded{
                        if isSucceeded{
                            self.loadingSpinner.stopAnimating()
                            if let categoriesModel = categoriesMapper?.groupsModel{
                                self.categoriesModel += categoriesModel
                                self.categoriesCollectionView.reloadData()
                            }
                        }
                    }
                }
            }, errorHandler: {error in
                DispatchQueue.main.async {
                    self.loadingSpinner.stopAnimating()
                    if error == ErrorType.NotConnected{
                        UIHelper.alertForNotConnected()
                    }else{
                        self.present(UIHelper.alertForError(), animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func getCategoryItems(id: String){
        self.loadingSpinner.startAnimating()
        let httpManager = HttpRestManager()
        print("\(Defaults.getBaseURL()!+"api/DN/POSMenuItems__m_Mozaic?view_group_id=\(id)&DOBID=\(Defaults.getDOBID()!)&StoreID=\(Defaults.getStoreId()!)&LangID=\(Defaults.getLanguage())&PageNumber=1")")
        
        httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSMenuItems__m_Mozaic?view_group_id=\(id)&DOBID=\(Defaults.getDOBID()!)&StoreID=\(Defaults.getStoreId()!)&LangID=\(Defaults.getLanguage())&PageNumber=1", connectionType: .None, resultHandler: { (stringData) in
            DispatchQueue.main.async {
                let result = httpManager.convertToDictionary(text: stringData)
                let itemsMapper = ItemsMapper(dictionary: result!)
                if let isSucceeded = itemsMapper?.isSucceeded{
                    if isSucceeded{
                        self.loadingSpinner.stopAnimating()
                        if let itemsModel = itemsMapper?.itemsModel{
                            self.itemsModel = itemsModel
                        }
                        if let totalNumberOfResults = itemsMapper?.totalNumberofResult{
                            if(totalNumberOfResults > Constants.IntConstants.pageCapacity){
                                let totalNumberOfPages = Constants.PagesCounter.getTotalNumberOfPages(totalNumberOfResults)
                                self.getCategoryItemsToPages(id: id, numberOfPages: totalNumberOfPages)
                            }
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.loadingSpinner.stopAnimating()
                if error == ErrorType.NotConnected{
                    UIHelper.alertForNotConnected()
                }else{
                    self.present(UIHelper.alertForError(), animated: true, completion: nil)
                }
            }
        }
    }
    
    func getCategoryItemsToPages(id: String, numberOfPages: Int){
        self.loadingSpinner.startAnimating()
        let httpManager = HttpRestManager()
        for page in 2 ... numberOfPages{
             print("\(Defaults.getBaseURL()!+"api/DN/POSMenuItems__m_Mozaic?view_group_id=\(id)&DOBID=\(Defaults.getDOBID()!)&StoreID=\(Defaults.getStoreId()!)&LangID=\(Defaults.getLanguage())&PageNumber=\(page)")")
            
            httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSMenuItems__m_Mozaic?view_group_id=\(id)&DOBID=\(Defaults.getDOBID()!)&StoreID=\(Defaults.getStoreId()!)&LangID=\(Defaults.getLanguage())&PageNumber=\(page)", connectionType: .None, resultHandler: {stringData in
                DispatchQueue.main.async {
                    let result = httpManager.convertToDictionary(text: stringData)
                    let itemsMapper = ItemsMapper(dictionary: result!)
                    if let isSucceeded = itemsMapper?.isSucceeded{
                        if isSucceeded{
                            self.loadingSpinner.stopAnimating()
                            if let itemsModel = itemsMapper?.itemsModel{
                                self.itemsModel += itemsModel
                            }
                        }
                    }
                }
            }, errorHandler: {error in
                DispatchQueue.main.async {
                    self.loadingSpinner.stopAnimating()
                    if error == ErrorType.NotConnected{
                        UIHelper.alertForNotConnected()
                    }
                }
            })
        }
    }


    // MARK: - Navigation
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuVCToAddedItemsSegue" {
            if let addedItemsVCX = segue.destination as? AddedItemsVCX {
                addedItemsVCX.selectedTable = self.selectedTable
                addedItemsVCX.existedOrderId = self.existedOrderId
            }
        }
    }
}

extension MenuVCX: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
        if let name = categoriesModel[indexPath.row].name{
            cell.categoryNameLabel.text = name
        }
        
        if categoriesModel[indexPath.row].isSelected{
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }else{
            cell.transform = .identity
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemsModel = [ItemsModel]()
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCell{
            for category in categoriesModel{
                category.isSelected = false
            }
            categoriesModel[indexPath.row].isSelected = true
            
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            collectionView.reloadSections([indexPath.section])
        }
        self.selectedCategory = categoriesModel[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.bounds.height - 20.0
        let height = width
        
        return CGSize(width: width, height: height)
    }
}

extension MenuVCX: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == itemsTableView{
            return itemsModel.count
        }else {
            return addedItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == itemsTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
            
            if let name = itemsModel[indexPath.row].displayName{
                cell.itemNameLabel.text = name
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddedItemsCell") as! AddedItemsCell
            
            cell.itemNameLabel.text = addedItems[indexPath.row].itemName
            cell.quantityLabel.text = "\(addedItems[indexPath.row].itemQuantity)"
            cell.totalPriceLabel.text = "\(addedItems[indexPath.row].itemTotal)"
            cell.increaseButton.tag = addedItems[indexPath.row].primaryKey
            cell.decreaseButton.tag = addedItems[indexPath.row].primaryKey
            cell.increaseButton.accessibilityHint = String(addedItems[indexPath.row].itemQuantity)
            cell.decreaseButton.accessibilityHint = String(addedItems[indexPath.row].itemQuantity)
           cell.increaseButton.addTarget(self.increaseItem, action: #selector(self.increaseItem), for: .touchUpInside)
            cell.decreaseButton.addTarget(self.decreaseItem, action: #selector(self.decreaseItem), for: .touchUpInside)
           
            var addOnsText = "\n"
            if addedItems[indexPath.row].itemAddOns.count > 0{
                for addOn in addedItems[indexPath.row].itemAddOns{
                    addOnsText += "  \(addOn.addOnName)\n"
                }
                cell.itemAddOnsLabel.text = addOnsText
            }else{
                cell.itemAddOnsLabel.text = "\n  \(Constants.LocalizedStrings.noAddOnsAvailable) \n"
            }
            return cell
        }
    }
     @IBAction func increaseItem(sender: UIButton){
        
        let quintity = Int(sender.accessibilityHint!)! + 1
        DataBaseManager.updateItemBy(primaryKey: sender.tag , quintity: quintity )

        
    }
    
    func decreaseItem(sender: UIButton){
        var quintity = Int(sender.accessibilityHint!)!
        if (quintity > 1) {
            quintity = quintity - 1
        }
        DataBaseManager.updateItemBy(primaryKey: sender.tag , quintity: quintity )
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let alertController = UIHelper.makeAlertController(alertTitle: "\(addedItems[indexPath.row].itemName)", alertMessage: Constants.LocalizedStrings.deleteItem, okString: Constants.LocalizedStrings.yes, cancelString: Constants.LocalizedStrings.cancel, needCancel: true, okActionHandler: {
                DataBaseManager.deleteItemBy(primaryKey: self.addedItems[indexPath.row].primaryKey)
                //self.addedItems.remove(at: indexPath.row)
                tableView.reloadSections([indexPath.section], with: .fade)
            }, cancelActionHandler: {})
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == addedItemsTableView{
            return true
        }else{
            return false
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == itemsTableView{
            if let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "AddItemPopUpVC") as? AddItemPopUpVC{
                popoverContent.selectedItem = itemsModel[indexPath.row]
                popoverContent.selectedCategory = self.selectedCategory
                popoverContent.selectedTable = self.selectedTable
                let navigationController = UIHelper.preparePopUp(popoverContent: popoverContent, currentController: self, currentDelegate: self)
                
                navigationController.modalTransitionStyle = .crossDissolve
                self.present(navigationController, animated: false, completion: nil)
                
            }
        }
    }
}




extension Double
{
    func truncate(places : Int)-> Double
    {
        var x = self
        x = x * 100
        x.round()
        x = x / 100
       
//        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
        return x
    }
}

