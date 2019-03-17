//
//  Constants.swift
//  Black Stone
//
//  Created by Waleed Jebreen on 7/6/17.
//  Copyright © 2017 Black Stone. All rights reserved.
//

import Foundation
import UIKit
public class Constants {
    internal class URLConstants{
        //internal static var BaseURL = "http://mozaic-dn.opos.me/"
        //internal static var ImageBaseURL = ""
        //internal static var BaseURL = "http://localhost:9971/"
        //internal static var BaseURL = ""
        
        internal static let appID = "1206257844"
    }
    
    internal class StringConstants{
        internal static var googleMapsAppKey = "AIzaSyAOybCmFc6M3GSMjZsTNPfYPexZnY4Cj-Q"
    }
    
    internal class MyColors{
        static let Red = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1.0)
        static let ArqamiBlue = UIColor(red: 10/255, green: 85/255, blue: 159/255, alpha: 1.0)
        static let LightGreen = UIColor(red: 129/255, green: 199/255, blue: 132/255, alpha: 1.0)
        static let LightBlack = UIColor(red: 40/255, green: 52/255, blue: 58/255, alpha: 1.0)
        static let DarkGreen = UIColor(red: 67/255, green: 160/255, blue: 71/255, alpha: 1.0)
        static let OffWhite = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        static let warningColor = UIColor(red: 243/256, green: 105/256, blue: 113/256, alpha: 1.0)
         static let grayBorderColor = UIColor(red: 104/256, green: 104/256, blue: 104/256, alpha: 1.0)
    }
    
    internal class LocalizedStrings{
        static let okbtn =  NSLocalizedString("ok", comment: "Ok")
        static let appName = NSLocalizedString("appname", comment: "appname")
        static let errorMessage =  NSLocalizedString("errorMessage", comment: "errorMessage")
        static let yes = NSLocalizedString("yes", comment: "yes")
        static let cancel = NSLocalizedString("cancel", comment: "cancel")
        static let deleteOrderItems = NSLocalizedString("deleteOrderItems", comment: "deleteOrderItems")
        static let deleteItem = NSLocalizedString("deleteItem", comment: "deleteItem")
        static let noAddOnsAvailable = NSLocalizedString("noAddOnsAvailable", comment: "noAddOnsAvailable")
        static let sureSendOrder = NSLocalizedString("sureSendOrder", comment: "sureSendOrder")
        static let internetConnection = NSLocalizedString("internetConnection", comment: "internetConnection")
        static let connectionMessage = NSLocalizedString("connectionMessage", comment: "connectionMessage")
        static let cantOpenOrders = NSLocalizedString("cantOpenOrders", comment: "cantOpenOrders")
        static let cantDeleteOrderItem = NSLocalizedString("cantDeleteOrderItem", comment: "cantDeleteOrderItem")
        static let cantSaveOrder = NSLocalizedString("cantSaveOrder", comment: "cantSaveOrder")
    }
    
    internal class IntConstants {
        static let pageCapacity = 10
    }
    
    internal class PagesCounter {
        static func getTotalNumberOfPages(_ totalNumberOfResults: Int) -> Int{
            var totalNumberOfPages: Int = 0
            if totalNumberOfResults > Constants.IntConstants.pageCapacity {
                if totalNumberOfResults % Constants.IntConstants.pageCapacity == 0 {
                    totalNumberOfPages = (totalNumberOfResults / Constants.IntConstants.pageCapacity)
                } else {
                    totalNumberOfPages = (totalNumberOfResults / Constants.IntConstants.pageCapacity) + 1
                }
            }
            return totalNumberOfPages
        }
    }
}

