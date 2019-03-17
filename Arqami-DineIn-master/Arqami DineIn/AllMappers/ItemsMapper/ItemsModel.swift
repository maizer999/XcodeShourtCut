/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class ItemsModel {
	public var itID : String?
	public var num : Int?
	public var displayName : String?
	public var name1 : String?
	public var name2 : String?
	public var uOMTypeID : String?
	public var iOrder : Int?
	public var qOH : Int?
	public var imageUrl : String?
	public var kitTypeID : Int?
    public var price : Double?
    public var itemUomID : String?
    public var IncludeTax : Int?
    public var TaxValue : Double?
    

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let itemsModel_list = ItemsModel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of ItemsModel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ItemsModel]
    {
        var models:[ItemsModel] = []
        for item in array
        {
            models.append(ItemsModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let itemsModel = ItemsModel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: ItemsModel Instance.
*/
    public init(){}
    
	required public init?(dictionary: NSDictionary) {

		itID = dictionary["itID"] as? String
		num = dictionary["Num"] as? Int
		displayName = dictionary["DisplayName"] as? String
		name1 = dictionary["Name1"] as? String
		name2 = dictionary["Name2"] as? String
		uOMTypeID = dictionary["UOMTypeID"] as? String
		iOrder = dictionary["iOrder"] as? Int
		qOH = dictionary["QOH"] as? Int
		imageUrl = dictionary["ImageUrl"] as? String
		kitTypeID = dictionary["KitTypeID"] as? Int
        price = dictionary["Price"] as? Double
        itemUomID = dictionary["ItemUomID"] as? String
        IncludeTax = dictionary["IncludeTax"] as? Int
        TaxValue = dictionary["TaxValue"] as? Double
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.itID, forKey: "itID")
		dictionary.setValue(self.num, forKey: "Num")
		dictionary.setValue(self.displayName, forKey: "DisplayName")
		dictionary.setValue(self.name1, forKey: "Name1")
		dictionary.setValue(self.name2, forKey: "Name2")
		dictionary.setValue(self.uOMTypeID, forKey: "UOMTypeID")
		dictionary.setValue(self.iOrder, forKey: "iOrder")
		dictionary.setValue(self.qOH, forKey: "QOH")
		dictionary.setValue(self.imageUrl, forKey: "ImageUrl")
		dictionary.setValue(self.kitTypeID, forKey: "KitTypeID")
        dictionary.setValue(self.price, forKey: "Price")
        dictionary.setValue(self.itemUomID, forKey: "ItemUomID")
        dictionary.setValue(self.TaxValue, forKey: "TaxValue")
        dictionary.setValue(self.IncludeTax, forKey: "IncludeTax")

		return dictionary
	}

}
