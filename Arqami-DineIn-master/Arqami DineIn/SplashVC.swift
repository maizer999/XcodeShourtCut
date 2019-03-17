//
//  SplashVC.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 9/24/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet weak var logoIcon: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.logoIcon.transform = CGAffineTransform(translationX: 0, y: -200)
        }, completion: { (true) in
            self.goToEnterUrl()
        })
    }
    
    func goToEnterUrl(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let enterUrlVC = storyboard.instantiateViewController(withIdentifier: "EnterUrlVC")
        enterUrlVC.modalTransitionStyle = .crossDissolve
        self.present(enterUrlVC, animated: true, completion: nil)
    }
}
