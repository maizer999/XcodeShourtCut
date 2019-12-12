//
//  ViewController.swift
//  pageView
//
//  Created by Mohammad Abu Maizer on 3/24/19.
//  Copyright © 2019 Mohammad Abu Maizer. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController   {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLabel: UILabel?
    var itemIndex: Int = 0
    var imageName: String?
    
    override func viewDidLoad()
    { super.viewDidLoad()
        if let currentImage = imageName {
            imageView.image = UIImage(named: currentImage)
            imageLabel?.text = currentImage }
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() // Dispose of any resources that can be recreated.
    }}




