//
//  Connection.swift
//  Black Stone
//
//  Created by Waleed Jebreen on 7/6/17.
//  Copyright © 2017 Black Stone. All rights reserved.
//
import Foundation

class Connection {
    
    static func isConnected() -> Bool{
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            return false
            
        case .online(.wiFi) , .online(.wwan):
            return true
        }
    }
}
