//
//  FavoriteVC.swift
//  Darahem
//
//  Created by Dulal Hossain on 11/9/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit

enum SegmentType {
    case offers
    case stores
}

class FavoriteVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!

    var products:[ProductModel] = []
    var stores = [StoreModel]()
    
    var segmentType:SegmentType = .offers{
        didSet{
            view.backgroundColor = segmentType == .offers ? Color.gray_xlight : .white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let editImage    = UIImage(named: "search_icon")!
        let searchImage  = UIImage(named: "filter icon")!
        
        let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(didTapEditButton))
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton))
        
        navigationItem.rightBarButtonItems = [editButton, searchButton,editButton]
        
        tableview.register(UINib.init(nibName: ProductCell.sbIdentifier, bundle: Bundle.main), forCellReuseIdentifier: ProductCell.sbIdentifier)
        tableview.delegate = self
        tableview.dataSource = self
        segmentType = .offers
    }
    
    @objc func didTapEditButton()  {
        
    }
    
    @objc func didTapSearchButton()  {
        
    }
    
    func loadProducts() {
        let params: [String : String] = [
            "user_id" : MyApplication.userID
            ]
        
        APIManager.apiConnection(param: params, url: "User/get_all_offers", method: .post, success: {(json) in
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
    
    func loadStores() {
        let params: [String : String] = [
            "user_id" : MyApplication.userID
            ]
        
        APIManager.apiConnection(param: params, url: "User/get_favorite_stores", method: .post, success: {(json) in
            let ret = json["status"].intValue
            self.stores.removeAll()
            if ret == 1 {
                let jsonAry = json["data"].arrayValue;
                for item in jsonAry {
                    let store = StoreModel()
                    store.initWithJson(data: item)
                    self.stores.append(store)
                }
            } else {
                self.showToast(message: json["message"].stringValue)
            }
            self.tableview.reloadData()
        })
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentType = .offers
            loadProducts()
        } else {
            segmentType = .stores
            loadStores()
        }
    }
    
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentType == .offers ? products.count : stores.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentType == .offers{
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
//            cell.favoriteAction = { product in
//            }
            cell.companyAction = { product in
                let vc = (UIStoryboard.storyBoard(storyBoard: .Main).instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListVC)
                vc.company = LocalizationSystem.shared.getLanguage() == "en" ? product.name : product.name_ar
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        let cell: StoreCell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
        cell.initWithStore(store: stores[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if segmentType == .stores { return }
        let vc:ProductDetailsVC = (UIStoryboard.storyBoard(storyBoard: .Main).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC)
        vc.product = products[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

