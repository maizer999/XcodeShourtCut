//
//  TableButton.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 10/17/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

class TableButton: UIButtonX {

    public var table = TablesModel()
    public var iD : String = ""
    public var name : String = ""{
        didSet{
            self.titleLabel!.font =  UIFont(name: "Arial", size: 14)
            self.setTitle(name, for: .normal)
        }
    }
    public var tablePrice : Double = 0.0
    public var statusID : Int = 0{
        didSet{
            switch statusID {
            case TableStatus.Available.rawValue:
                self.backgroundColor = UIColor.green
            case TableStatus.Occupied.rawValue:
                self.backgroundColor = UIColor.red
            case TableStatus.Reserved.rawValue:
                self.backgroundColor = UIColor.yellow
            default:
                self.backgroundColor = Constants.MyColors.ArqamiBlue
            }
        }
    }
    public var orderValue : Double = 0.0
    public var tablePosTop : Double = 0.0
    public var tablePosLeft : Double = 0.0

}
