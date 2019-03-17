/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class ItemRemarksModel {
	public var iD : String?
	public var name : String?
	public var itemID : String?
	public var itemUOmID : String?
	public var qty : Int?
	public var order : Int?
	public var price : Double?
    public var isSelected = false

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let itemRemarksModel_list = ItemRemarksModel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of ItemRemarksModel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ItemRemarksModel]
    {
        var models:[ItemRemarksModel] = []
        for item in array
        {
            models.append(ItemRemarksModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let itemRemarksModel = ItemRemarksModel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: ItemRemarksModel Instance.
*/
	required public init?(dictionary: NSDictionary) {

		iD = dictionary["ID"] as? String
		name = dictionary["Name"] as? String
		itemID = dictionary["ItemID"] as? String
		itemUOmID = dictionary["ItemUOmID"] as? String
		qty = dictionary["Qty"] as? Int
		order = dictionary["Order"] as? Int
		price = dictionary["Price"] as? Double
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.iD, forKey: "ID")
		dictionary.setValue(self.name, forKey: "Name")
		dictionary.setValue(self.itemID, forKey: "ItemID")
		dictionary.setValue(self.itemUOmID, forKey: "ItemUOmID")
		dictionary.setValue(self.qty, forKey: "Qty")
		dictionary.setValue(self.order, forKey: "Order")
		dictionary.setValue(self.price, forKey: "Price")

		return dictionary
	}

}
