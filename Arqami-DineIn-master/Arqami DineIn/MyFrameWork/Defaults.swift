//
//  Defaults.swift
//  Black Stone
//
//  Created by Waleed Jebreen on 7/6/17.
//  Copyright © 2017 Black Stone. All rights reserved.
//

import Foundation

class Defaults{
    static func setLanguage(lang: Int){
        let defaults = UserDefaults.standard
        defaults.set(lang, forKey: "UserLanguage")
    }
    
    static func getLanguage() -> Int{
        let defaults = UserDefaults.standard
        let lang = defaults.integer(forKey: "UserLanguage")
        return lang
    }
    
    
    static func setIncludeTax(includeTax: Int){
        let defaults = UserDefaults.standard
        defaults.set(includeTax, forKey: "IncludeTax")
    }
    
    static func getIncludeTax() -> Int{
        let defaults = UserDefaults.standard
        let includeTax = defaults.integer(forKey: "IncludeTax")
        return includeTax
    }
    
    
    
    static func setStoreId(id: String){
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: "StoreId")
    }
    
    static func getStoreId() -> String?{
        let defaults = UserDefaults.standard
        if let id = defaults.string(forKey: "StoreId"){
            return id
        }
        return nil
    }
    
    static func setStoreName(name: String){
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "StoreName")
    }
    
    static func getStoreName() -> String?{
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "StoreName"){
            return name
        }
        return nil
    }
    
    static func setDOBID(dobid: String){
        let defaults = UserDefaults.standard
        defaults.set(dobid, forKey: "DOBID")
    }
    
    static func getDOBID() -> String?{
        let defaults = UserDefaults.standard
        if let id = defaults.string(forKey: "DOBID"){
            return id
        }
        return nil
    }
    
    static func setUserID(userId: String){
        let defaults = UserDefaults.standard
        defaults.set(userId, forKey: "UserID")
    }
    
    static func getUserID() -> String?{
        let defaults = UserDefaults.standard
        if let id = defaults.string(forKey: "UserID"){
            return id
        }
        return nil
    }
    
    static func setBaseURL(baseUrl: String){
        let defaults = UserDefaults.standard
        defaults.set(baseUrl, forKey: "BaseURL")
    }
    
    static func getBaseURL() -> String?{
        let defaults = UserDefaults.standard
        if let baseUrl = defaults.string(forKey: "BaseURL"){
            return baseUrl
        }
        return nil
    }
    
    static func setCanOpenOrders(bool: Bool){
        let defaults = UserDefaults.standard
        defaults.set(bool, forKey: "CanOpenOrders")
    }
    
    static func getCanOpenOrders() -> Bool{
        let defaults = UserDefaults.standard
        let bool = defaults.bool(forKey: "CanOpenOrders")
        return bool
    }
    
    static func setCanDeleteOrderItem(bool: Bool){
        let defaults = UserDefaults.standard
        defaults.set(bool, forKey: "CanDeleteOrderItem")
    }
    
    static func getCanDeleteOrderItem() -> Bool{
        let defaults = UserDefaults.standard
        let bool = defaults.bool(forKey: "CanDeleteOrderItem")
        return bool
    }
    
    static func setCanSaveOrder(bool: Bool){
        let defaults = UserDefaults.standard
        defaults.set(bool, forKey: "CanSaveOrder")
    }
    
    static func getCanSaveOrder() -> Bool{
        let defaults = UserDefaults.standard
        let bool = defaults.bool(forKey: "CanSaveOrder")
        return bool
    }
}
