//
//  HallAndTableVC.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 9/24/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

class HallAndTableVC: UIViewController {

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var hallsCollectionView: UICollectionViewX!
    @IBOutlet weak var tablesCollectionView: UICollectionView!
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
    
    var tablesModel = [TablesModel](){
        didSet{
            self.tablesCollectionView.reloadData()
        }
    }
    var selectedTable = TablesModel()
    
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
                            self.tablesModel = tablesModel
                        }
                        if let totalNumberOfResults = tablesMapper?.totalNumberofResult{
                            if(totalNumberOfResults > Constants.IntConstants.pageCapacity){
                                let totalNumberOfPages = Constants.PagesCounter.getTotalNumberOfPages(totalNumberOfResults)
                                self.getTablesToPages(id: id, numberOfPages: totalNumberOfPages)
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
    
    func getTablesToPages(id: String, numberOfPages: Int){
        self.loadingSpinner.startAnimating()
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
                                self.tablesModel += tablesModel
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TablesToMenuSegue" {
            if let menuVCX = segue.destination as? MenuVCX {
                menuVCX.selectedTable = self.selectedTable
            }
        }
    }
}

extension HallAndTableVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hallsCollectionView{
            return hallModel.count
        }else{
            return tablesModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hallsCollectionView{
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
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TableCell", for: indexPath) as! TableCell

            if let status = tablesModel[indexPath.row].statusID{
                switch status {
                case TableStatus.Available.rawValue:
                    cell.backGroundView.backgroundColor = UIColor.green
                case TableStatus.Occupied.rawValue:
                    cell.backGroundView.backgroundColor = UIColor.red
                case TableStatus.Reserved.rawValue:
                    cell.backGroundView.backgroundColor = UIColor.yellow
                default:
                    cell.backGroundView.backgroundColor = Constants.MyColors.ArqamiBlue
                }
            }
            
            if let name = tablesModel[indexPath.row].name{
                cell.tableNameLabel.text = name
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == hallsCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? HallCell{
                for hall in hallModel{
                    hall.isSelected = false
                }
                hallModel[indexPath.row].isSelected = true
                
                self.selectedHall = hallModel[indexPath.row]
                cell.selectionView.backgroundColor = UIColor.clear
                cell.hallNameLabel.textColor = UIColor.darkGray
                collectionView.reloadSections([indexPath.section])
            }
        }else{
            self.selectedTable = tablesModel[indexPath.row]
            performSegue(withIdentifier: "TablesToMenuSegue", sender: nil)
        }
    }
    
    
   
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == hallsCollectionView{
            let width = Int(collectionView.bounds.width)/hallModel.count
            let height = collectionView.bounds.height
            return CGSize(width: CGFloat(width), height: height)
        }else{
            let width = collectionView.bounds.width/8
            let height = width
            
            return CGSize(width: width, height: height)
        }
    }
}


//@maizer update 01/04/2018
extension UIView {
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
}

