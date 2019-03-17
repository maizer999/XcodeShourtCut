/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class TablesModel {
	public var iD : String?
	public var name : String?
	public var tablePrice : Double?
	public var statusID : Int?
	public var orderValue : Double?
    public var tablePosTop : Double?
    public var tablePosLeft : Double?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let tablesModel_list = TablesModel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of TablesModel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [TablesModel]
    {
        var models:[TablesModel] = []
        for item in array
        {
            models.append(TablesModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let tablesModel = TablesModel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: TablesModel Instance.
*/
    public init(){}
    
	required public init?(dictionary: NSDictionary) {

		iD = dictionary["ID"] as? String
		name = dictionary["Name"] as? String
		tablePrice = dictionary["TablePrice"] as? Double
		statusID = dictionary["StatusID"] as? Int
		orderValue = dictionary["OrderValue"] as? Double
        tablePosTop = dictionary["TablePosTop"] as? Double
        tablePosLeft = dictionary["TablePosLeft"] as? Double
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.iD, forKey: "ID")
		dictionary.setValue(self.name, forKey: "Name")
		dictionary.setValue(self.tablePrice, forKey: "TablePrice")
		dictionary.setValue(self.statusID, forKey: "StatusID")
		dictionary.setValue(self.orderValue, forKey: "OrderValue")
        dictionary.setValue(self.tablePosTop, forKey: "TablePosTop")
        dictionary.setValue(self.tablePosLeft, forKey: "TablePosLeft")

		return dictionary
	}

}
