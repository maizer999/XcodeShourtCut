//
//  LogInVC.swift
//  Arqami DineIn
//
//  Created by Waleed Jebreen on 9/24/17.
//  Copyright © 2017 Mozaicis. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var userNameTF: UITextFieldX!
    @IBOutlet weak var passwordTF: UITextFieldX!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let cantOpenOrders = Constants.LocalizedStrings.cantOpenOrders
    let appName = Constants.LocalizedStrings.appName
    let ok = Constants.LocalizedStrings.okbtn
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print("\(Defaults.getLanguage())")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let scrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.scrollViewTapped))
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(scrollViewTapGesture)
        // Do any additional setup after loading the view.
    }
    //MARK:- LogIn Action
    @IBAction func logInAction() {
        if userNameTF.text != ""{
            userNameTF.makeWarning(bool: false)
            let userName = userNameTF.text!
            if passwordTF.text != ""{
                passwordTF.makeWarning(bool: false)
                let password = passwordTF.text!
                makeLogIn(userName: userName, password: password)
            }else{
                UIHelper.shakeAnimation(passwordTF)
                passwordTF.makeWarning(bool: true)
            }
        }else{
            UIHelper.shakeAnimation(userNameTF)
            userNameTF.makeWarning(bool: true)
        }
    }
    
    func makeLogIn(userName: String,password: String){
        self.loadingSpinner.startAnimating()
        logInButton.isUserInteractionEnabled = false
        logInButton.alpha = 0.6
        let httpManager = HttpRestManager()
        httpManager.get(url: Defaults.getBaseURL()!+"api/DN/POSLogin__m_Mozaic?UserID=\(userName)&Pass=\(password)&StoreID=\(Defaults.getStoreId()!)&LangID=\(Defaults.getLanguage())", connectionType: .None, resultHandler: { (stringData) in
            DispatchQueue.main.async {
                let result = httpManager.convertToDictionary(text: stringData)
                let logInMapper = LogInMapper(dictionary: result!)
                if let isSucceeded = logInMapper?.isSucceeded{
                    if isSucceeded{
                        self.logInButton.isUserInteractionEnabled = true
                        self.logInButton.alpha = 1
                        self.loadingSpinner.stopAnimating()
                        
                        if let user = logInMapper?.loginModel{
                            if user.count > 0{
                                
                                if let canOpenOrders = user[0].canOpenOrders{
                                    Defaults.setCanOpenOrders(bool: canOpenOrders)
                                    
                                    if canOpenOrders{
                                        
                                        if let userId = user[0].iD{
                                            Defaults.setUserID(userId: userId)
                                        }
                                        
                                        if let canDeleteOrderItem = user[0].canDeleteOrderItem{
                                            Defaults.setCanDeleteOrderItem(bool: canDeleteOrderItem)
                                        }
                                        
                                        if let canSaveOrder = user[0].canSaveOrder{
                                            Defaults.setCanSaveOrder(bool: canSaveOrder)
                                        }
                                        
                                        if let dobid = user[0].dOBID{
                                            Defaults.setDOBID(dobid: dobid)
                                            self.goToHallAndTable()
                                        }
                                        
                                    }else{
                                       let alertController = UIHelper.makeAlertController(alertTitle: self.appName, alertMessage: self.cantOpenOrders, okString: self.ok, okActionHandler: {}, cancelActionHandler: {})
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.logInButton.isUserInteractionEnabled = true
                self.logInButton.alpha = 1
                self.loadingSpinner.stopAnimating()
                if error == ErrorType.NotConnected{
                    UIHelper.alertForNotConnected()
                }else{
                    self.present(UIHelper.alertForError(), animated: true, completion: nil)
                }
            }
        }
    }
    
    func goToHallAndTable(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hallAndTableVC = storyboard.instantiateViewController(withIdentifier: "HallAndTableNav")
        hallAndTableVC.modalTransitionStyle = .crossDissolve
        self.present(hallAndTableVC, animated: true, completion: nil)
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
