//
//  SecurityManager.swift
//  theCakeShop
//
//  Created by Waleed Jebreen on 12/27/16.
//  Copyright © 2016 Mozaic Innovative Solutions. All rights reserved.
//

import Foundation

class SecurityManager{
    
    static func getAuthenticationToken(connectionType: ConnectionType) -> String?{
        let defaults = UserDefaults.standard
        switch connectionType {
        case .UserId:
            if(defaults.integer(forKey: ConnectionType.UserId.rawValue) != 0){
                return "\(defaults.integer(forKey: ConnectionType.UserId.rawValue))"
            }
        case .ClientId:
            if(defaults.integer(forKey: ConnectionType.ClientId.rawValue) != 0){
                return "\(defaults.integer(forKey: ConnectionType.ClientId.rawValue))"
            }
        case .None:
            break
        }
        return nil
    }
    
    static func setAuthenticationToken(_ connectionType: ConnectionType, value: Int?){
        let defaults = UserDefaults.standard
        switch connectionType {
        case .UserId:
            defaults.set(value, forKey: ConnectionType.UserId.rawValue)
        case .ClientId:
            defaults.set(value, forKey: ConnectionType.ClientId.rawValue)
        case .None:
            break
        }
    }
}
