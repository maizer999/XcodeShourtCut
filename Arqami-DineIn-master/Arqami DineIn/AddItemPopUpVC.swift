//
//  AddItemPopUpVC.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 9/25/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemPopUpVC: UIViewController, UITextViewDelegate {

    var selectedItem = ItemsModel()
    var selectedCategory = GroupsModel()
    var selectedTable = TablesModel()
    
    var itemRemarksModel = [ItemRemarksModel](){
        didSet{
            if itemRemarksModel.count > 0{
                noRemarksHintLabel.isHidden = true
                remarksTableView.reloadData()
            }
        }
    }
    
    var priceChange = 0.0{
        didSet{
            calculatePrice()
        }
    }
    
    var quantity = 1{
        didSet{
            self.quantityLabel.text = "\(quantity)"
            calculatePrice()
        }
    }
    
    var totalPrice = 0.0{
        didSet{
            self.priceLabel.text = "\(totalPrice)"
        }
    }
    
    
    
    var instructionsSelected = false

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var noRemarksHintLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var remarksTableView: UITableView!
    
    @IBOutlet weak var instructionsTV: UITextViewX!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("\(DataBaseManager.getFileURL())")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let scrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.scrollViewTapped))
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(scrollViewTapGesture)
        
        if let itemPrice = selectedItem.price{
            totalPrice = Double(itemPrice)
        }
        
        if let itemName = selectedItem.displayName{
            itemNameLabel.text = itemName
        }
        
        instructionsTV.delegate = self

        getItemRemarks()

        // Do any additional setup after loading the view.
    }
    
    func getItemRemarks(){
        self.loadingSpinner.startAnimating()
        let language = Defaults.getLanguage()
        let httpManager = HttpRestManager()
        if let categoryId = selectedCategory.iD{
            httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSItemRemarks__m_Mozaic?GroupID=\(categoryId)&StoreID=\(Defaults.getStoreId()!)&LangID=\(language)&PageNumber=1", connectionType: .None, resultHandler: { (stringData) in
                DispatchQueue.main.async {
                    let result = httpManager.convertToDictionary(text: stringData)
                    let remarksMapper = RemarksMapper(dictionary: result!)
                    if let isSucceeded = remarksMapper?.isSucceeded{
                        if isSucceeded{
                            self.loadingSpinner.stopAnimating()
                            if let itemRemarksModel = remarksMapper?.itemRemarksModel{
                                self.itemRemarksModel = itemRemarksModel
                            }
                            if let totalNumberOfResults = remarksMapper?.totalNumberofResult{
                                if(totalNumberOfResults > Constants.IntConstants.pageCapacity){
                                    let totalNumberOfPages = Constants.PagesCounter.getTotalNumberOfPages(totalNumberOfResults)
                                    self.getItemRemarksToPages(numberOfPages: totalNumberOfPages)
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
    }
    
    func getItemRemarksToPages(numberOfPages: Int){
        let language = Defaults.getLanguage()
        self.loadingSpinner.startAnimating()
        let httpManager = HttpRestManager()
        if let categoryId = selectedCategory.iD{
            for page in 2 ... numberOfPages{
                httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSItemRemarks__m_Mozaic?GroupID=\(categoryId)&StoreID=\(Defaults.getStoreId()!)&LangID=\(language)&PageNumber=\(page)", connectionType: .None, resultHandler: {stringData in
                    DispatchQueue.main.async {
                        let result = httpManager.convertToDictionary(text: stringData)
                        let remarksMapper = RemarksMapper(dictionary: result!)
                        if let isSucceeded = remarksMapper?.isSucceeded{
                            if isSucceeded{
                                self.loadingSpinner.stopAnimating()
                                if let itemRemarksModel = remarksMapper?.itemRemarksModel{
                                    self.itemRemarksModel += itemRemarksModel
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
    }
    
    func calculatePrice(){
        if let itemPrice = selectedItem.price{
            let newPrice = (Double(itemPrice) + priceChange) * Double(quantity)
            totalPrice = newPrice
        }
    }
    
    @IBAction func addToTableAction() {
        let itemAddOns = List<ItemAddOns>()
        for remark in itemRemarksModel{
            if remark.isSelected{
                if let remarkId = remark.iD{
                    if let remarkName = remark.name{
                        if let remarkPrice = remark.price{
                            let itemAddOn = ItemAddOns()
                            itemAddOn.addOnId = remarkId
                            itemAddOn.addOnName = remarkName
                            itemAddOn.addOnPrice = remarkPrice
                            itemAddOns.append(itemAddOn)
                        }
                    }
                }
            }
        }
        
        if let otherInstructions = instructionsTV.text{
            if otherInstructions != ""{
                let itemAddOn = ItemAddOns()
                itemAddOn.addOnId = ""
                itemAddOn.addOnName = otherInstructions
                itemAddOn.addOnPrice = 0.0
                itemAddOns.append(itemAddOn)
            }
        }

        
        
        let tableItem = TableItem()
        if let tableId = selectedTable.iD{
            if let itemPrice = selectedItem.price{
                if let itemUOMId = selectedItem.itemUomID{
                    if let itemId = selectedItem.itID{
                        if let  IncludeTax = selectedItem.IncludeTax {
                              if let  TaxValue = selectedItem.TaxValue {
                                if let itemName = selectedItem.displayName{
                            tableItem.primaryKey = DataBaseManager.getItemsMaxPrimaryKey() + 1
                            tableItem.tableId = tableId
                            tableItem.itemId = itemId
                            tableItem.itemPrice = Double(itemPrice) + self.priceChange
                            tableItem.itemUOMId = itemUOMId
                            tableItem.itemName = itemName
                            tableItem.itemQuantity = self.quantity
                            tableItem.itemTotal = self.totalPrice
                            tableItem.itemAddOns = itemAddOns
                            tableItem.IncludeTax = IncludeTax
                            tableItem.TaxValue = TaxValue
                            tableItem.RemPrice = self.priceChange
                            print("\(tableItem.itemPrice )")
                            print("\( self.priceChange )")
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
                    DataBaseManager.addItemToTable(tableItem: tableItem, tableId: tableId)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    let table = Table()
                    table.tableId = tableId
                    table.tableName = tableName
                    DataBaseManager.addTable(table: table)
                    DataBaseManager.addItemToTable(tableItem: tableItem, tableId: tableId)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func plusAction() {
        quantity += 1
    }
    
    @IBAction func minusAction() {
        if(quantity > 1){
            quantity -= 1
        }
    }
}

extension AddItemPopUpVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemRemarksModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemRemarksCell") as! ItemRemarksCell
        
        if let remarkName = itemRemarksModel[indexPath.row].name{
            cell.remarkNameLabel.text = remarkName
        }
        
        if let remarkPrice = itemRemarksModel[indexPath.row].price{
            cell.priceLabel.text = "\(remarkPrice)"
        }
        
        if itemRemarksModel[indexPath.row].isSelected {
            cell.boxButton.isSelected = true
        }else{
            cell.boxButton.isSelected = false
        }
        cell.boxButton.row = indexPath.row
        cell.boxButton.section = indexPath.section
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let itemRemarksCell = cell as? ItemRemarksCell {
            didPressBox(sender: itemRemarksCell.boxButton)
        }
    }

    func didPressBox(sender: CheckBoxButtons){
        if itemRemarksModel[sender.row!].isSelected{
            if let price = itemRemarksModel[sender.row!].price{
                self.priceChange -= price
            }
        }else{
            if let price = itemRemarksModel[sender.row!].price{
                self.priceChange += price
            }
        }
        
        self.itemRemarksModel[sender.row!].isSelected = !itemRemarksModel[sender.row!].isSelected
        self.remarksTableView.reloadSections([sender.section!], with: .fade)
    }
    
    // MARK: - KeyBoard Apperance
    func keyboardWillShow(_ notification:Notification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
//        let point = CGPoint(x: 0, y: keyboardFrame.size.height / 2)
//        self.scrollView.contentOffset = point
        
        self.scrollView.scrollToView(view: instructionsTV, animated: true)
    }
    
    func keyboardWillHide(_ notification:Notification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    func scrollViewTapped(){
        view.endEditing(true)
    }
    
    //MARK:- TextView Delegates
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == ""{
            self.placeHolderLabel.isHidden = false
        }else{
            self.placeHolderLabel.isHidden = true
        }
    }
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.contentOffset = CGPoint(x: 0,y: childStartPoint.y)
        }
    }
}
