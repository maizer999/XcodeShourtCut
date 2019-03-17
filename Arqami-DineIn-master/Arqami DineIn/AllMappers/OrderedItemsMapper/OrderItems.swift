/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class OrderItems {
    public var orderItemPK : String?
	public var itemID : String?
	public var itemUOMID : String?
	public var itemName : String?
	public var itemQty : Int?
	public var itemPrice : Double?
    public var itemTotal : Double?
    public var SubTotal : Double?
    public var TaxTotal : Double?
    public var IncludeTax : Int?
    public var ItemTax : Double?
    
	public var remPrice : Int?
	public var itemRemark : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let orderItems_list = OrderItems.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of OrderItems Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderItems]
    {
        var models:[OrderItems] = []
        for item in array
        {
            models.append(OrderItems(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let orderItems = OrderItems(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: OrderItems Instance.
*/
	required public init?(dictionary: NSDictionary) {

        orderItemPK = dictionary["OrderItemPK"] as? String
		itemID = dictionary["itemID"] as? String
		itemUOMID = dictionary["ItemUOMID"] as? String
		itemName = dictionary["ItemName"] as? String
		itemQty = dictionary["ItemQty"] as? Int
		itemPrice = dictionary["ItemPrice"] as? Double
		itemTotal = dictionary["ItemTotal"] as? Double
		remPrice = dictionary["RemPrice"] as? Int
		itemRemark = dictionary["ItemRemark"] as? String
        IncludeTax  = dictionary["IncludeTax"] as? Int
        ItemTax = dictionary["ItemTax"] as? Double
        SubTotal = dictionary["SubTotal"] as? Double
        TaxTotal = dictionary["TaxTotal"] as? Double
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

        dictionary.setValue(self.orderItemPK, forKey: "OrderItemPK")
		dictionary.setValue(self.itemID, forKey: "itemID")
		dictionary.setValue(self.itemUOMID, forKey: "ItemUOMID")
		dictionary.setValue(self.itemName, forKey: "ItemName")
		dictionary.setValue(self.itemQty, forKey: "ItemQty")
		dictionary.setValue(self.itemPrice, forKey: "ItemPrice")
		dictionary.setValue(self.itemTotal, forKey: "ItemTotal")
        dictionary.setValue(self.remPrice, forKey: "RemPrice")
        dictionary.setValue(self.itemRemark, forKey: "ItemRemark")
        dictionary.setValue(self.IncludeTax, forKey: "IncludeTax")
        dictionary.setValue(self.SubTotal, forKey: "SubTotal")
        dictionary.setValue(self.ItemTax, forKey: "ItemTax")
   

		return dictionary
	}

}
