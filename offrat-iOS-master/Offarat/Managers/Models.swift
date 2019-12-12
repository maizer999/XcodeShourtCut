//
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryModel: Codable, Equatable {
    
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = 0
    var name = ""
    var name_ar = ""
    var imgUrl = ""
    var isExpand = false
    var subCategories = [SubCategoryModel]()
    
    func initWithJson(data json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        name_ar = json["name_ar"].stringValue
        imgUrl = json["image"].stringValue
        
        let subAry = json["sub_cat"].arrayValue
        for subJson in subAry {
            let subItem = SubCategoryModel()
            subItem.initWithJson(data: subJson)
            subCategories.append(subItem)
        }
    }
}

class SubCategoryModel: Codable {
    
    var id = 0
    var name = ""
    var name_ar="";
    var img_url="";
    
    func initWithJson(data json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        name_ar = json["name_ar"].stringValue
        img_url = json["image"].stringValue
    }
}

class ProductModel: Codable {
    
    var id = ""
    var name = ""
    var name_ar = ""
    var imgUrl = ""
    var favorite = ""
    var category_id = ""

    var offer = ""
    var startDate = ""
    var endDate = ""
    var webAddress = ""
    var phoneNumber = ""
    var latitude = ""
    var longitude = ""
    
//    JSONObject store_data = cur.getJSONObject("store_data");
//    id = cur.getString("id");
//    name = cur.getString("tags");
//    name_ar = cur.getString("tags_ar");
//    offer_price = cur.getString("offer_price");
//    category_id = cur.getString("category_id");
//    img_url = cur.getString("img");
//    store_id = cur.getString("store_id");
//    detail = cur.getString("details");
//    detail_ar = cur.getString("details_ar");
//    from_date = cur.getString("from_date");
//    to_date = cur.getString("to_date");
//    favorite_status = cur.getString("is_favorite");
//    mobile = store_data.getString("contact");
//    latitude = store_data.getString("latitude");
//    longitude = store_data.getString("longitude");
    
    func initWithJson(data json: JSON) {
        id = json["id"].stringValue
        name = json["tags"].stringValue
        name_ar = json["tags_ar"].stringValue
        imgUrl = json["img"].stringValue
        favorite = json["is_favorite"].stringValue
        category_id = json["category_id"].stringValue
        
        offer = json["is_favorite"].stringValue
        startDate = json["from_date"].stringValue
        endDate = json["to_date"].stringValue
        webAddress = ""
        let jsonData = json["store_data"]
        phoneNumber = jsonData["contact"].stringValue
        latitude = jsonData["latitude"].stringValue
        longitude = jsonData["longitude"].stringValue
        
        
    }
}

class StoreModel: Codable {
    var id = "";
    var name = "";
    var name_ar = "";
    var imgUrl = "";
    var location = "";
    var location_ar = "";
    
    var latitude = "";
    var longitude = "";
    var contact = "";
    var email = "";
    var created_date = "";
    var favorite_date = "";
    
    func initWithJson(data json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        name_ar = json["name_ar"].stringValue
        imgUrl = json["thumbnail"].stringValue
        location = json["location"].stringValue
        location_ar = json["location_ar"].stringValue
        
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        contact = json["contact"].stringValue
        email = json["email"].stringValue
        created_date = json["created_date"].stringValue
        favorite_date = json["favorite_date"].stringValue
    }
}
