//
//  APIManager.swift
//  Offarat
//
//  Created by JinYZ on 12/8/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class APIManager: NSObject {
    
    static let serverUrl = "https://offarat.space/offarat/index.php/"
    
    static func apiConnection(param: [String: String], url: String, method: HTTPMethod, success: @escaping ((JSON) -> Void)) {
        onShowProgressView(name: "Connecting...")
        Alamofire.request(serverUrl + url, method: method, parameters: param).validate().responseJSON { (response) in
            if response.error != nil {
                onhideProgressView()
                return
            }
            if let data = response.result.value {
                let json = JSON.init(data)
                success(json)
            }
            onhideProgressView()
        }
    }
    
    static func onShowProgressView (name: String) {
        SVProgressHUD.show(withStatus: name)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setForegroundColor (UIColor(red: 38.0/255, green: 202/255, blue: 248.0/255, alpha: 1.0))
        SVProgressHUD.setBackgroundColor (UIColor.white.withAlphaComponent(1.0))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingNoTextRadius(20)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
    }
    
    static func onhideProgressView() {
        SVProgressHUD.dismiss()
    }
    
}
