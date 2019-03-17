//
//  EnterUrlVC.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 10/10/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

class EnterUrlVC: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBOutlet weak var urlTF: UITextFieldX!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let scrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.scrollViewTapped))
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(scrollViewTapGesture)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let url = Defaults.getBaseURL(){
            urlTF.text = url
        }
    }
    
    @IBAction func setBaseUrlAction(){
        if urlTF.text != ""{
            let baseUrl = urlTF.text!
            Defaults.setBaseURL(baseUrl: baseUrl)
            print("\(Defaults.getBaseURL)")
            if let _ = Defaults.getStoreId(){
                self.goToLogIn()
            }else{
                self.performSegue(withIdentifier: "URLToStoresSegue", sender: nil)
            }
        }else{
            UIHelper.shakeAnimation(urlTF)
            urlTF.makeWarning(bool: true)
        }
    }
    
    func goToLogIn(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInVC")
        logInVC.modalTransitionStyle = .crossDissolve
        self.present(logInVC, animated: true, completion: nil)
    }

    // MARK: - KeyBoard Apperance
    func keyboardWillShow(_ notification:Notification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification:Notification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    func scrollViewTapped(){
        view.endEditing(true)
    }

}
