//
//  CategoryListVC.swift
//  Offarat
//
//  Created by JinYZ on 12/9/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit

class CategoryListVC: UIViewController {
    
    @IBOutlet weak var listUTV: UITableView!
    
    var products: [ProductModel] = []
    var company = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if company == "" {
            loadProductsWithCategory()
            navigationItem.title = "By Category"
        } else {
            navigationItem.title = "By Company"
            loadProductsWithCompany()
        }
        
        listUTV.register(UINib.init(nibName: ProductCell.sbIdentifier, bundle: Bundle.main), forCellReuseIdentifier: ProductCell.sbIdentifier)
    }
    
    func loadProductsWithCategory() {
        let params: [String : String] = [
            "user_id" : MyApplication.userID,
            "cat_id" : MyApplication.supCategory,
            "sub_cat_id" : MyApplication.subCategory
            ]
        
        APIManager.apiConnection(param: params, url: "User/get_all_offer_bycategory", method: .post, success: {(json) in
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
            self.listUTV.reloadData()
        })
    }
    
    func loadProductsWithCompany() {
        let params: [String : String] = [
            "company_name" : company
            ]
        
        APIManager.apiConnection(param: params, url: "User/get_hot_offers_with_comapny_name", method: .post, success: {(json) in
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
            self.listUTV.reloadData()
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
        listUTV.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoryListVC: UITableViewDataSource {
    
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
        cell.locationAction = { prodcut in
            MyApplication.openMap(latitude: prodcut.latitude, longitude: prodcut.longitude)
        }
        cell.callAction = { product in
            MyApplication.callAction(phoneNumber: product.phoneNumber)
        }
        cell.favoriteAction = { product in
            let status = product.favorite == "0" ? "1" : "0"
            self.set_favorite_offer(statu: status, category_id: product.category_id, offer_id: product.id)
        }
        cell.companyAction = { product in
            let vc = (UIStoryboard.storyBoard(storyBoard: .Main).instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListVC)
            vc.company = LocalizationSystem.shared.getLanguage() == "en" ? product.name : product.name_ar
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
}

extension CategoryListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc:ProductDetailsVC = (UIStoryboard.storyBoard(storyBoard: .Main).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC)
        vc.product = products[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
