//
//  UIButtonX.swift
//  Black Stone
//
//  Created by Waleed Jebreen on 8/15/17.
//  Copyright © 2017 Black Stone. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonX: UIButton {

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
