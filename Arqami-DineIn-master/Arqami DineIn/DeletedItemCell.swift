//
//  DeletedItemCell.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 10/8/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

class DeletedItemCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
