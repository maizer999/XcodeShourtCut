//
//  MenuVC.swift
//  iCheckVehicles
//
//  Created by Dulal Hossain on 8/8/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var selectCategoryTitleLabel: UILabel!
    @IBOutlet weak var allCategoryTitleLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    var catagories:[CategoryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.reloadData()
        menuTableView.register(UINib.init(nibName: "MenuFooterCell", bundle: Bundle.main), forCellReuseIdentifier: "MenuFooterCell")
        selectCategoryTitleLabel.text = SelectCategory.localizedValue()
        allCategoryTitleLabel.text = AllCategory.localizedValue()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.catagories = MyApplication.allCategories
        self.menuTableView.reloadData()
    }
    
    @IBAction func allCategoryAction(_ sender: UIButton) {
        Presenter.shared.openClose()
        Presenter.shared.changeTab(2)
    }
    
}

extension MenuVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return catagories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = catagories[section]
        let isExpnd = sec.isExpand
        if !(isExpnd) {
            return 0
        }
        return  isExpnd ? sec.subCategories.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subCat = catagories[indexPath.section].subCategories[indexPath.row]
        let cell: MenuTableCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath) as! MenuTableCell
        
        cell.filled(subCat)
        return cell
    }
    
}

extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let subCat = catagories[indexPath.section].subCategories[indexPath.row]
        MyApplication.supCategory = ""
        MyApplication.subCategory = "\(subCat.id)"
        
        Presenter.shared.openClose()
        Presenter.shared.onShowDetailProduct()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: MenuHeaderView = MenuHeaderView.fromNib()
        headerView.headerTap = { [weak self] in
            let supCategory = self?.catagories[section]
            if (supCategory?.subCategories.count)! > 0 {
                if let expnd = supCategory?.isExpand, expnd == true{
                    supCategory?.isExpand = false
                    tableView.reloadSections([section], with: .automatic)
                    return
                } else {
                    for cate in self!.catagories {
                        cate.isExpand = false
                    }
                    supCategory?.isExpand = true
                    tableView.reloadData()
                }
            } else {
                MyApplication.supCategory = "\(supCategory!.id)"
                MyApplication.subCategory = ""
                
                Presenter.shared.openClose()
                Presenter.shared.onShowDetailProduct()
            }
        }
        headerView.fill(catagories[section])
        return headerView
    }
}



