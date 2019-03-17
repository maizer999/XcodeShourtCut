//
//  AddedItemsCell.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 9/26/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

class AddedItemsCell: UITableViewCell {

    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var itemAddOnsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
