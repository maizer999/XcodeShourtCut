//
//  UILabelX.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 9/26/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

@IBDesignable
class UILabelX: UILabel {

    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

}
