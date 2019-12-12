//
//
//  Created by Dulal Hossain on 12/10/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit

class CatagoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!

    var addRemoveAction:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(_ cate: CategoryModel) {
        nameLabel.text = LocalizationSystem.shared.getLanguage() == "en" ? cate.name : cate.name_ar
        let lang = LocalizationSystem.shared.getLanguage()
        nameLabel.text = lang == "en" ? cate.name : cate.name_ar
        categoryImageView.onShowImgWithUrl(link: cate.imgUrl)
    }
  
}

class BorderView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Color.colorPrimary.cgColor
        layer.masksToBounds = false
    }
}




