/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class OrderModel {
	public var orderID : String?
	public var waiterID : String?
	public var custID : String?
	public var userID : String?
	public var remarks : String?
	public var custName : String?
	public var itemRemarkswithIDs : String?
	public var mobile : String?
    public var total : Double?
    public var TaxTotal : Double?
    public var SubTotal : Double?
	public var occSeats : Int?
	public var orderItems : Array<OrderItems>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let orderModel_list = OrderModel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of OrderModel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderModel]
    {
        var models:[OrderModel] = []
        for item in array
        {
            models.append(OrderModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let orderModel = OrderModel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: OrderModel Instance.
*/
	required public init?(dictionary: NSDictionary) {

		orderID = dictionary["OrderID"] as? String
		waiterID = dictionary["WaiterID"] as? String
		custID = dictionary["CustID"] as? String
		userID = dictionary["UserID"] as? String
		remarks = dictionary["Remarks"] as? String
		custName = dictionary["CustName"] as? String
		itemRemarkswithIDs = dictionary["ItemRemarkswithIDs"] as? String
		mobile = dictionary["Mobile"] as? String
        total = dictionary["Total"] as? Double
        SubTotal = dictionary["SubTotal"] as? Double
        TaxTotal = dictionary["TaxTotal"] as? Double
        occSeats = dictionary["OccSeats"] as? Int
        if let _ = dictionary["OrderItems"] as? NSArray{
            if (dictionary["OrderItems"] != nil) { orderItems = OrderItems.modelsFromDictionaryArray(array: dictionary["OrderItems"] as! NSArray) }
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.orderID, forKey: "OrderID")
		dictionary.setValue(self.waiterID, forKey: "WaiterID")
		dictionary.setValue(self.custID, forKey: "CustID")
		dictionary.setValue(self.userID, forKey: "UserID")
		dictionary.setValue(self.remarks, forKey: "Remarks")
		dictionary.setValue(self.custName, forKey: "CustName")
		dictionary.setValue(self.itemRemarkswithIDs, forKey: "ItemRemarkswithIDs")
		dictionary.setValue(self.mobile, forKey: "Mobile")
        dictionary.setValue(self.total, forKey: "Total")
        dictionary.setValue(self.SubTotal, forKey: "SubTotal")
        dictionary.setValue(self.TaxTotal, forKey: "TaxTotal")
		dictionary.setValue(self.occSeats, forKey: "OccSeats")

		return dictionary
	}

}
