//
//  CountryViewController.swift
//  Wish
//
//  Created by Waleed Jebreen on 11/25/16.
//  Copyright © 2016 Mozaic Innovative Solutions. All rights reserved.
//

import UIKit

class StoresViewController: UITableViewController, UISearchBarDelegate {
    //MARK:- PropartiesAndOutlets
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    var filtered:[String] = []
    var tableCountryNames = [String]()
    var tableData : [[String : AnyObject]] = []
    
    //MARK:- ApplicationLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        initUI()

        getStores()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    //MARK:- SearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = tableCountryNames.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    //MARK:- TableView DataSource And Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive == true){
            return filtered.count
        }
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:StoresTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "StoresTableViewCell") as! StoresTableViewCell
        
        if(tableCountryNames.count == 0){
            for i in 0..<tableData.count {
                if let name = tableData[i]["Name"]! as? String{
                    tableCountryNames.append(name)
                }
            }
        }
        
        if(searchActive && filtered.count != 0){
            cell.countryName.text = filtered[indexPath.row]
        }else{
            cell.countryName.text = "\(tableData[indexPath.row]["Name"]!)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        if(filtered.count != 0){
            let name = filtered[indexPath.row]
            for counter in 0..<tableData.count{
                if(name == tableData[counter]["Name"] as! String){
                    if let id = tableData[counter]["ID"] as? String{
                        Defaults.setStoreId(id: id)
                        Defaults.setStoreName(name: name)
                    }
                }
            }
            goToLogIn()
        }else{
            if let id = tableData[indexPath.row]["ID"] as? String{
                Defaults.setStoreId(id: id)
            }
            if let name = tableData[indexPath.row]["Name"] as? String{
                Defaults.setStoreName(name: name)
            }
            goToLogIn()
        }
    }
    
    func goToLogIn(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInVC")
        logInVC.modalTransitionStyle = .crossDissolve
        self.present(logInVC, animated: true, completion: nil)
    }
    
    //MARK:- Get Countries From API
    func getStores(){
        let httpManager = HttpRestManager()
        let language = Defaults.getLanguage()
        
        print("getBaseURL  \( Defaults.getBaseURL()!+"api/DN/POSStores__m_Mozaic?langID=\(language)&PageNumber=1")")
        httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSStores__m_Mozaic?langID=\(language)&PageNumber=1", connectionType: .None, resultHandler: {stringData in
            DispatchQueue.main.async{
                let result = httpManager.convertToDictionary(text: stringData)
                if (result?.count != 0){
                    //sccess
                    if let jsonData = result?["StoresModel"] as? [[String : AnyObject]]{
                        self.tableData = jsonData
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                        self.loadingView.isHidden = true
                    }
                }
            }
        }, errorHandler: {error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if error == ErrorType.NotConnected{
                    UIHelper.alertForNotConnected()
                }else{
                    self.present(UIHelper.alertForError(), animated: true, completion: nil)
                }
            }
        })
    }
 //MARK:- UIInitialization
    func initUI(){
        activityIndicator.startAnimating()
    }
}
