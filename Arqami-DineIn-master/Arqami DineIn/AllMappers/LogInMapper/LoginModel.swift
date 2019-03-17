/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class LoginModel {
	public var iD : String?
	public var name : String?
	public var loginName : String?
	public var inActive : String?
	public var isAdmin : String?
	public var isWaiter : String?
	public var roleID : String?
	public var canOpenOrders : Bool?
	public var canDeleteOrderItem : Bool?
	public var canSaveOrder : Bool?
	public var dOBID : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let loginModel_list = LoginModel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of LoginModel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [LoginModel]
    {
        var models:[LoginModel] = []
        for item in array
        {
            models.append(LoginModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let loginModel = LoginModel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: LoginModel Instance.
*/
	required public init?(dictionary: NSDictionary) {

		iD = dictionary["ID"] as? String
		name = dictionary["Name"] as? String
		loginName = dictionary["LoginName"] as? String
		inActive = dictionary["InActive"] as? String
		isAdmin = dictionary["IsAdmin"] as? String
		isWaiter = dictionary["IsWaiter"] as? String
		roleID = dictionary["RoleID"] as? String
		canOpenOrders = dictionary["CanOpenOrders"] as? Bool
		canDeleteOrderItem = dictionary["CanDeleteOrderItem"] as? Bool
		canSaveOrder = dictionary["CanSaveOrder"] as? Bool
		dOBID = dictionary["DOBID"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.iD, forKey: "ID")
		dictionary.setValue(self.name, forKey: "Name")
		dictionary.setValue(self.loginName, forKey: "LoginName")
		dictionary.setValue(self.inActive, forKey: "InActive")
		dictionary.setValue(self.isAdmin, forKey: "IsAdmin")
		dictionary.setValue(self.isWaiter, forKey: "IsWaiter")
		dictionary.setValue(self.roleID, forKey: "RoleID")
		dictionary.setValue(self.canOpenOrders, forKey: "CanOpenOrders")
		dictionary.setValue(self.canDeleteOrderItem, forKey: "CanDeleteOrderItem")
		dictionary.setValue(self.canSaveOrder, forKey: "CanSaveOrder")
		dictionary.setValue(self.dOBID, forKey: "DOBID")

		return dictionary
	}

}
