//
//  BeautyProductsVC.swift
//
//
//  Created by Dulal Hossain on 11/9/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit

class BeautyProductsVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var products:[ProductModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MyApplication.sortStr == "" {
            loadProducts()
        } else {
            loadProductsWithSort()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            tableview.register(UINib.init(nibName: ProductCell.sbIdentifier, bundle: Bundle.main), forCellReuseIdentifier: ProductCell.sbIdentifier)
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func loadProducts() {
        let params: [String : String] = [
            "user_id" : MyApplication.userID
            ]
        
        APIManager.apiConnection(param: params, url: "User/get_hot_offers_all", method: .post, success: {(json) in
            print(json)
            let ret = json["status"].intValue
            self.products.removeAll()
            if ret == 1 {
                let jsonAry = json["data"].arrayValue;
                for item in jsonAry {
                    let product = ProductModel()
                    product.initWithJson(data: item)
                    self.products.append(product)
                }
            } else {
                self.showToast(message: json["message"].stringValue)
            }
            self.tableview.reloadData()
        })
    }
    
    func loadProductsWithSort() {
        let params: [String : String] = [
            "user_id" : MyApplication.userID,
            "sort_by" : MyApplication.sortStr
            ]
        
        APIManager.apiConnection(param: params, url: "User/get_offers_bychepest_nearest", method: .post, success: {(json) in
            let ret = json["status"].intValue
            self.products.removeAll()
            if ret == 1 {
                let jsonAry = json["data"].arrayValue;
                for item in jsonAry {
                    let product = ProductModel()
                    product.initWithJson(data: item)
                    self.products.append(product)
                }
            } else {
                self.showToast(message: json["message"].stringValue)
            }
            self.tableview.reloadData()
        })
    }
    
    func set_favorite_offer(statu: String, category_id: String, offer_id: String){
        let params: [String : String] = [
        "user_id" : MyApplication.userID,
        "offer_id" : category_id,
        "is_favorite" : statu
        ]
        
        APIManager.apiConnection(param: params, url: "User/select_favorite_offer", method: .post, success: {(json) in
            let ret = json["status"].intValue
            if ret == 1 {
                self.showToast(message: json["message"].stringValue)
                self.onEventResetList(offer_id: offer_id)
            } else {
                self.showToast(message: "Server Error")
            }
        })
    }
    
    func onEventResetList(offer_id: String) {
        for product in products {
            if product.id == offer_id {
                product.favorite = product.favorite == "0" ? "1" : "0"
            }
        }
        tableview.reloadData()
    }
}


extension BeautyProductsVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProductCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.fill(products[indexPath.row])
        
        cell.shareAction = { product in
            self.showShareController()            
        }
        cell.favoriteAction = { product in
            let status = product.favorite == "0" ? "1" : "0"
            self.set_favorite_offer(statu: status, category_id: product.category_id, offer_id: product.id)
        }
        cell.locationAction = { prodcut in
            MyApplication.openMap(latitude: prodcut.latitude, longitude: prodcut.longitude)
        }
        cell.callAction = { product in
            MyApplication.callAction(phoneNumber: product.phoneNumber)
        }
        cell.companyAction = { product in
            let vc = (UIStoryboard.storyBoard(storyBoard: .Main).instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListVC)
            vc.company = LocalizationSystem.shared.getLanguage() == "en" ? product.name : product.name_ar
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc:ProductDetailsVC = (UIStoryboard.storyBoard(storyBoard: .Main).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC)
        vc.product = products[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


