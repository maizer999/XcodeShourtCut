//
//  UIHelper.swift
//  Mozaic
//
//  Created by Waleed Jebreen on 11/20/16.
//  Copyright © 2016 Mozaic Innovative Solutions. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import JDropDownAlert

class UIHelper {
    /*
    static func makePopUp(popoverContent: UIViewController, currentController: UIViewController, currentDelegate: UIPopoverPresentationControllerDelegate) -> UINavigationController{
        let navigationController = UINavigationController(rootViewController: popoverContent)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController.isNavigationBarHidden = true
        
        let popover = navigationController.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: currentController.view.frame.width/1.3, height: currentController.view.frame.height*0.3)
        popover?.sourceView?.isUserInteractionEnabled = true
        popover?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        popover?.delegate = currentDelegate
        popover?.sourceView = currentController.view
        popover?.sourceRect = CGRect(x: UIScreen.main.bounds.midX,y: UIScreen.main.bounds.midY,width: 0,height: 0)
        
        return navigationController
    }
    
    static func makeImagePopUp(popoverContent: UIViewController, currentController: UIViewController, currentDelegate: UIPopoverPresentationControllerDelegate) -> UINavigationController{
        let navigationController = UINavigationController(rootViewController: popoverContent)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController.isNavigationBarHidden = true
        
        let popover = navigationController.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: currentController.view.frame.width, height: currentController.view.frame.height*0.4)
        popover?.sourceView?.isUserInteractionEnabled = true
        popover?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        popover?.delegate = currentDelegate
        popover?.sourceView = currentController.view
        popover?.sourceRect = CGRect(x: UIScreen.main.bounds.midX,y: UIScreen.main.bounds.midY,width: 0,height: 0)
        
        return navigationController
    }
    
    static func makeRatingPopUp(popoverContent: UIViewController, currentController: UIViewController, currentDelegate: UIPopoverPresentationControllerDelegate) -> UINavigationController{
        let navigationController = UINavigationController(rootViewController: popoverContent)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController.isNavigationBarHidden = true
        
        let popover = navigationController.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: currentController.view.frame.width, height: currentController.view.frame.height*0.6)
        popover?.sourceView?.isUserInteractionEnabled = true
        popover?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        popover?.delegate = currentDelegate
        popover?.sourceView = currentController.view
        popover?.sourceRect = CGRect(x: UIScreen.main.bounds.midX,y: UIScreen.main.bounds.midY,width: 0,height: 0)
        
        return navigationController
    }
    */
    static func makeAlertController(alertTitle title: String,alertMessage message: String, okString okStr: String, cancelString cancelStr: String = "", needCancel cancel: Bool = false, okActionHandler: @escaping () -> Void, cancelActionHandler: @escaping () -> Void) -> UIAlertController{

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okStr, style: .default) { (action:UIAlertAction!) in
            
            okActionHandler()
        }
        
        if(cancel){
            let cancelAction = UIAlertAction(title: cancelStr, style: .cancel) { (action:UIAlertAction!) in
                cancelActionHandler()
            }
            
            alertController.addAction(cancelAction)
        }
        
        alertController.addAction(okAction)
        
        
        let titleAttributedString = NSAttributedString(string: title, attributes: [NSFontAttributeName : UIFont.init(name: "Gill Sans", size: CGFloat(20))!,NSForegroundColorAttributeName : UIColor.black])
        
        let messageAttributedString = NSAttributedString(string: message, attributes: [NSFontAttributeName : UIFont.init(name: "Gill Sans", size: CGFloat(15))!,NSForegroundColorAttributeName : UIColor.black])
        
        alertController.setValue(titleAttributedString, forKey: "attributedTitle")
        
        alertController.setValue(messageAttributedString, forKey: "attributedMessage")
        
        return alertController
        
    }
    
    static func alertForNotConnected(){
        let titleString = Constants.LocalizedStrings.internetConnection
        let messageString = Constants.LocalizedStrings.connectionMessage
        
        let alert = JDropDownAlert(position: .top, direction: .normal)
        alert.titleFont = UIFont.init(name: "Gill Sans", size: 17)!
        alert.messageFont = UIFont.init(name: "Gill Sans", size: 12)!
        
        alert.alertWith(titleString,
                        message: messageString,
                        topLabelColor: UIColor.white,
                        messageLabelColor: UIColor.white,
                        backgroundColor: UIColor.red)
        
        //            alert.didTapBlock = {
        //                print("Top View Did Tapped")
        //            }
    }
 
    
    static func preparePopUp(popoverContent: UIViewController, currentController: UIViewController, currentDelegate: UIPopoverPresentationControllerDelegate) -> UINavigationController{
        let navigationController = UINavigationController(rootViewController: popoverContent)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController.isNavigationBarHidden = true
        
        let popover = navigationController.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: currentController.view.frame.width, height: currentController.view.frame.height*0.4)
        popover?.sourceView?.isUserInteractionEnabled = true
        popover?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        popover?.delegate = currentDelegate
        popover?.sourceView = currentController.view
        popover?.sourceRect = CGRect(x: UIScreen.main.bounds.midX,y: UIScreen.main.bounds.midY,width: 0,height: 0)
        
        return navigationController
    }
    
    static func circleAnimation(_ view: UIView){
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            
            view.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        })
        UIView.animate(withDuration: 2.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            
            view.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2))
        }, completion: nil)
        
    }
    
    static func pulseAnimation(_ view: UIView){
        view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 10.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        view.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  })
    }
    
    static func shakeAnimation(_ view: UIView){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
    
    static func fadeInAnimation(_ view: UIView, delay late: TimeInterval){
        view.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: late, options: UIViewAnimationOptions.curveEaseIn, animations: {
            view.alpha = 1.0
        }, completion: {(finished:Bool) in
            
        })
    }
    
    static func makePlaceHolder(_ textField: UITextField, text: String){
        textField.attributedPlaceholder = NSAttributedString(string: text,attributes:[NSForegroundColorAttributeName: UIColor.white])
    }
    
    static func alertForError() -> UIAlertController{
        
        let alertController = UIAlertController(title: Constants.LocalizedStrings.appName, message: Constants.LocalizedStrings.errorMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: Constants.LocalizedStrings.okbtn, style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(OKAction)        
        return alertController
    }
    /*
    static func alertForEnablingPushNotifications() -> UIAlertController{
        let notificationsAlertTitle = BusinessConstants.LocalizedStrings.notificationsAlertTitle
        let notificationsAlertMessage = BusinessConstants.LocalizedStrings.notificationsAlertMessage
        let notificationOk = BusinessConstants.LocalizedStrings.okbtn
        
        let alertController = UIHelper.makeAlertController(alertTitle: notificationsAlertTitle, alertMessage: notificationsAlertMessage, okString: notificationOk, okActionHandler: {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                // Fallback on earlier versions
            }
            
            
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            } else {
                // Fallback on earlier versions
                let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            
        }, cancelActionHandler: {})
        
        return alertController
    }
    
    static func notAvailableAlert() -> UIAlertController{
        let appName = BusinessConstants.LocalizedStrings.appName
        let notAvailableAlertMessage = BusinessConstants.LocalizedStrings.notAvailableAlertMessage
        let ok = BusinessConstants.LocalizedStrings.okbtn
        
        let alertController = UIHelper.makeAlertController(alertTitle: appName, alertMessage: notAvailableAlertMessage, okString: ok, okActionHandler: {}, cancelActionHandler: {})
        
        let titleAttributedString = NSAttributedString(string: BusinessConstants.LocalizedStrings.appName, attributes: [NSFontAttributeName : UIFont.init(name: "Pangram-Bold", size: CGFloat(20))!,NSForegroundColorAttributeName : UIColor.black])
        
        let messageAttributedString = NSAttributedString(string: BusinessConstants.LocalizedStrings.notAvailableAlertMessage, attributes: [NSFontAttributeName : UIFont.init(name: "Pangram-Regular", size: CGFloat(15))!,NSForegroundColorAttributeName : UIColor.black])
        
        alertController.setValue(titleAttributedString, forKey: "attributedTitle")
        
        alertController.setValue(messageAttributedString, forKey: "attributedMessage")
        
        return alertController
    }
    
    static func alertForRegister(okActionHandler: @escaping () -> Void) -> UIAlertController{
        
        let alertController = UIAlertController(title: BusinessConstants.LocalizedStrings.appName, message: BusinessConstants.LocalizedStrings.registerMessage, preferredStyle: .actionSheet)
        let OKAction = UIAlertAction(title: BusinessConstants.LocalizedStrings.registerButton, style: .default) { (action:UIAlertAction!) in
            okActionHandler()
        }
        let cancelAction = UIAlertAction(title: BusinessConstants.LocalizedStrings.cancel, style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        
        let titleAttributedString = NSAttributedString(string: BusinessConstants.LocalizedStrings.appName, attributes: [NSFontAttributeName : UIFont.init(name: "Pangram-Bold", size: CGFloat(20))!,NSForegroundColorAttributeName : UIColor.black])
        
        let messageAttributedString = NSAttributedString(string: BusinessConstants.LocalizedStrings.registerMessage, attributes: [NSFontAttributeName : UIFont.init(name: "Pangram-Regular", size: CGFloat(15))!,NSForegroundColorAttributeName : UIColor.black])
        
        alertController.setValue(titleAttributedString, forKey: "attributedTitle")
        
        alertController.setValue(messageAttributedString, forKey: "attributedMessage")
        
        return alertController
    }
 
    static func initNavigationBarWithTitle(_ view: UIViewController , _ title:String){
        view.navigationController?.navigationBar.barTintColor = Constants.MyColors.DarkGreen
        view.navigationController?.navigationBar.isTranslucent = false
        view.navigationController?.navigationBar.tintColor = UIColor.white
        view.navigationItem.title = title
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Arial", size: CGFloat(17))!]
        view.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : AnyObject])
        
        let barButtonTitleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Arial", size: 17)!]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonTitleDict as! [String : AnyObject], for: UIControlState.normal)
    }
     
     static func initNavigationBar(_ view: UIViewController){
     view.navigationController?.navigationBar.barTintColor = Constants.MyColors.DarkGreen
     view.navigationController?.navigationBar.isTranslucent = false
     view.navigationController?.navigationBar.tintColor = UIColor.white
     let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Arial", size: CGFloat(17))!]
     view.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : AnyObject])
     
     let barButtonTitleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Arial", size: 17)!]
     UIBarButtonItem.appearance().setTitleTextAttributes(barButtonTitleDict as! [String : AnyObject], for: UIControlState.normal)
     }
    */
    static func initTransperantNavigationBar(_ view: UIViewController){
        view.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        view.navigationController?.navigationBar.backgroundColor = UIColor.clear
        view.navigationController?.navigationBar.shadowImage = UIImage()
        view.navigationController?.navigationBar.isTranslucent = true
        view.navigationController?.navigationBar.tintColor = UIColor.white
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Gill Sans", size: CGFloat(17))!]
        view.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : AnyObject])
        
        let barButtonTitleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Gill Sans", size: 17)!]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonTitleDict as! [String : AnyObject], for: UIControlState.normal)
    }
    
    static func initTransperantNavigationBarWithTitle(_ view: UIViewController, _ title:String){
        view.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        view.navigationController?.navigationBar.backgroundColor = UIColor.clear
        view.navigationController?.navigationBar.shadowImage = UIImage()
        view.navigationController?.navigationBar.isTranslucent = true
        view.navigationItem.title = title
        view.navigationController?.navigationBar.tintColor = UIColor.white
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Gill Sans", size: CGFloat(17))!]
        view.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : AnyObject])
        
        let barButtonTitleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Gill Sans", size: 17)!]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonTitleDict as! [String : AnyObject], for: UIControlState.normal)
    }

    static func makeDatePicker() -> UIDatePicker{
        //let calendar = Calendar(identifier:Calendar.Identifier.gregorian);
        let todayDate = NSDate()
        let maxDate = todayDate.addDays(daysToAdd: 30)
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.minimumDate = todayDate as Date
        datePickerView.maximumDate = maxDate as Date
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        return datePickerView
    }
    
    static func datePickerFormatter() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.locale = Locale(identifier: "en_MU")
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "MM/dd/yyy"
        
        return dateFormatter
    }
    
    static func makeToolBar(title: String, vc: UIViewController, selector: Selector) -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.barTintColor = Constants.MyColors.LightBlack
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.2)
        gradientLayer.endPoint = CGPoint(x: 2.5, y: 2.5)
        
        gradientLayer.frame = toolBar.bounds
        
        gradientLayer.colors = [Constants.MyColors.LightBlack.cgColor, Constants.MyColors.LightGreen.cgColor]
        
        toolBar.layer.addSublayer(gradientLayer)
        
        let doneButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: vc, action: selector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}


extension UIView {
 
    func slideInFromLeft(_ duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
    
        let slideInFromLeftTransition = CATransition()

        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    func slideInFromRight(_ duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromRightTransition = CATransition()

        // Customize the animation's properties
        slideInFromRightTransition.type = kCATransitionPush
        slideInFromRightTransition.subtype = kCATransitionFromRight
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromRightTransition, forKey: "slideInFromRightTransition")
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}
