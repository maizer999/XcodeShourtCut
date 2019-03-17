//
//  AddItemPopUpCell.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 9/25/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

class ItemRemarksCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var remarkNameLabel: UILabel!
    @IBOutlet weak var boxButton: CheckBoxButtons!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
