//
//  HallAndTableVCX.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 10/17/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

class HallAndTableVCX: UIViewController {
    
    var hallModel = [HallModel](){
        didSet{
            hallsCollectionView.reloadData()
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            for hall in hallModel{
                hall.isSelected = false
            }
            
            hallModel[0].isSelected = true
            self.selectedHall = hallModel[0]
            hallsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            collectionView(hallsCollectionView, didSelectItemAt: indexPath)
        }
    }
    
    var selectedHall = HallModel(){
        didSet{
            if let id = selectedHall.iD{
                tablesModel = [TablesModel]()
                getTables(id: id)
            }
        }
    }
    var selectedTable = TablesModel()
    

    var tablesModel = [TablesModel](){
        didSet{
            print("ablesModel.count   \(tablesModel.count)")
            var tableButtonsArray = [TableButton]()
            for table in tablesModel{
                let tableButton = TableButton()
                
                tableButton.table = table
                
                if let id = table.iD{
                    tableButton.iD = id
                }
                if let name = table.name{
                    tableButton.name = name
                }
                if let tablePrice = table.tablePrice{
                    tableButton.tablePrice = tablePrice
                }
                if let status = table.statusID{
                    tableButton.statusID = status
                }
                if let orderValue = table.orderValue{
                    tableButton.orderValue = orderValue
                }
                if let tablePosTop = table.tablePosTop{
                    tableButton.tablePosTop = tablePosTop
                }
                if let tablePosLeft = table.tablePosLeft{
                    tableButton.tablePosLeft = tablePosLeft
                }
                tableButtonsArray.append(tableButton)
            }
            self.tableButtonsArray = tableButtonsArray
        }
    }
    
    var tableButtonsArray = [TableButton](){
        didSet{
            let panelWidth = Double(self.panelView.frame.size.width)
            let panelHeight = Double(self.panelView.frame.size.height)
            
            let buttonWidthPercent = 77.0 / 790.0
            let buttonHeightPercent = 70.0 / 400.0
            
            let panelWidthRatio = panelWidth / 790
            let panelHeightRatio = panelHeight / 400
            
            let buttonWidth = buttonWidthPercent * panelWidth - 20
            let buttonHeight = buttonHeightPercent * panelHeight - 20
            
            print("tableButtonsArray  \(tableButtonsArray.count)")
            
            for button in tableButtonsArray{
                
                button.translatesAutoresizingMaskIntoConstraints = false
                panelView.addSubview(button)
                button.addTarget(self, action: #selector(self.tablePressed(sender:)), for: .touchUpInside)
                
                let topConstant = CGFloat(button.tablePosTop * panelHeightRatio)
                let leadingConstant = CGFloat(button.tablePosLeft * panelWidthRatio)
                
                let verticalConstraint = NSLayoutConstraint(item: button,
                                                            attribute: NSLayoutAttribute.top,
                                                            relatedBy: NSLayoutRelation.equal,
                                                            toItem: panelView,
                                                            attribute: NSLayoutAttribute.top,
                                                            multiplier: 1,
                                                            constant: topConstant)
                let widthConstraint = NSLayoutConstraint(item: button,
                                                         attribute: NSLayoutAttribute.width,
                                                         relatedBy: NSLayoutRelation.equal,
                                                         toItem: nil,
                                                         attribute: NSLayoutAttribute.notAnAttribute,
                                                         multiplier: 1,
                                                         constant: CGFloat(buttonWidth))
                let heightConstraint = NSLayoutConstraint(item: button,
                                                          attribute: NSLayoutAttribute.height,
                                                          relatedBy: NSLayoutRelation.equal,
                                                          toItem: nil,
                                                          attribute: NSLayoutAttribute.notAnAttribute,
                                                          multiplier: 1,
                                                          constant: CGFloat(buttonHeight))
                let leadingConstraint = NSLayoutConstraint(item: button,
                                                            attribute: NSLayoutAttribute.leading,
                                                            relatedBy: NSLayoutRelation.equal,
                                                            toItem: panelView,
                                                            attribute: NSLayoutAttribute.leading,
                                                            multiplier: 1,
                                                            constant: leadingConstant)
                
                button.addConstraints([widthConstraint, heightConstraint])
                panelView.addConstraints([verticalConstraint, leadingConstraint])
            }
        }
    }
    
    @IBOutlet weak var hallsCollectionView: UICollectionViewX!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHalls()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let id = selectedHall.iD{
            getTables(id: id)
        }
    }
    
    func tablePressed(sender: TableButton!) {
        self.selectedTable = sender.table
        performSegue(withIdentifier: "TablesToMenuSegue", sender: nil)
    }
    
    func getHalls(){
        self.loadingSpinner.startAnimating()
        let httpManager = HttpRestManager()
        httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSHall__m_Mozaic?PageNumber=1", connectionType: .None, resultHandler: { (stringData) in
            DispatchQueue.main.async {
                let result = httpManager.convertToDictionary(text: stringData)
                let hallsMapper = HallsMapper(dictionary: result!)
                if let isSucceeded = hallsMapper?.isSucceeded{
                    if isSucceeded{
                        self.loadingSpinner.stopAnimating()
                        if let hallModel = hallsMapper?.hallModel{
                            self.hallModel = hallModel
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

    func getTables(id: String){
        self.loadingSpinner.startAnimating()
        let httpManager = HttpRestManager()
        httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSTables__m_Mozaic?hl_hall_id=\(id)&PageNumber=1", connectionType: .None, resultHandler: { (stringData) in
            DispatchQueue.main.async {
                let result = httpManager.convertToDictionary(text: stringData)
                let tablesMapper = TablesMapper(dictionary: result!)
                if let isSucceeded = tablesMapper?.isSucceeded{
                    if isSucceeded{
                        self.loadingSpinner.stopAnimating()
                        if let tablesModel = tablesMapper?.tablesModel{
                        
                            if let totalNumberOfResults = tablesMapper?.totalNumberofResult{
                                if(totalNumberOfResults > Constants.IntConstants.pageCapacity){
                                    let totalNumberOfPages = Constants.PagesCounter.getTotalNumberOfPages(totalNumberOfResults)
                                    self.getTablesToPages(id: id, numberOfPages: totalNumberOfPages, data: tablesModel)
                                }else{
                                    self.tablesModel = tablesModel
                                }
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
    
    func getTablesToPages(id: String, numberOfPages: Int, data: [TablesModel]){
        self.loadingSpinner.startAnimating()
        
        var allTables = data
        
        let httpManager = HttpRestManager()
        for page in 2 ... numberOfPages{
            httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSTables__m_Mozaic?hl_hall_id=\(id)&PageNumber=\(page)", connectionType: .None, resultHandler: {stringData in
                DispatchQueue.main.async {
                    let result = httpManager.convertToDictionary(text: stringData)
                    let tablesMapper = TablesMapper(dictionary: result!)
                    if let isSucceeded = tablesMapper?.isSucceeded{
                        if isSucceeded{
                            self.loadingSpinner.stopAnimating()
                            if let tablesModel = tablesMapper?.tablesModel{
                                allTables += tablesModel
                                self.tablesModel = allTables
                            }
                        }else{
                            self.tablesModel = allTables
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
        //self.tablesModel = allTables
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TablesToMenuSegue" {
            if let menuVCX = segue.destination as? MenuVCX {
                menuVCX.selectedTable = self.selectedTable
            }
        }
    }
}

extension HallAndTableVCX: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hallModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HallCell", for: indexPath) as! HallCell
        
        if let name = hallModel[indexPath.row].name{
            cell.hallNameLabel.text = name
        }
        
        if hallModel[indexPath.row].isSelected{
            cell.selectionView.backgroundColor = Constants.MyColors.ArqamiBlue
            cell.hallNameLabel.textColor = UIColor.white
        }else{
            cell.selectionView.backgroundColor = UIColor.clear
             //@maizer update 01/04/2018
            cell.selectionView.borders(for: [.left, .bottom], width: 0.8, color:  Constants.MyColors.grayBorderColor)
            cell.hallNameLabel.textColor = Constants.MyColors.ArqamiBlue
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HallCell{
            
            for view in panelView.subviews{
                view.removeFromSuperview()
            }
            
            for hall in hallModel{
                hall.isSelected = false
            }
            hallModel[indexPath.row].isSelected = true
            
            self.selectedHall = hallModel[indexPath.row]
            cell.selectionView.backgroundColor = UIColor.clear
            cell.hallNameLabel.textColor = UIColor.darkGray
            collectionView.reloadSections([indexPath.section])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = Int(collectionView.bounds.width)/hallModel.count
        let height = collectionView.bounds.height
        
        return CGSize(width: CGFloat(width), height: height)
    }
}
