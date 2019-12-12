//
//  Presenter.swift
//  Offarat
//
//  Created by Dulal Hossain on 2/11/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit

class Presenter {
    
    static var shared:Presenter = Presenter()
    
    private init(){
    }
    
    func setTabbarAsRoot(_ index: Int = 2) {
        let drawer: UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let homeVC =  UIStoryboard.storyBoard(storyBoard: .Main).instantiateViewController(HomeTabbarController.self)
        
        let homeNav: UINavigationController = UINavigationController.init(rootViewController: homeVC)
        homeNav.navigationBar.tintColor = Color.colorPrimary
        let menu: MenuVC = drawer.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        
        let drawerController = DrawerVC(drawerDirection: LocalizationSystem.shared.getLanguage() == "en" ? .left:.right, drawerWidth: 300)
        drawerController.mainViewController = homeNav
        drawerController.drawerViewController = menu
        (homeVC as UITabBarController).selectedIndex = index
      
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = drawerController
        }
    }
    
    func setDrawer(_ homeVC: UIViewController) {
        let drawer: UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let homeNav: UINavigationController = UINavigationController.init(rootViewController: homeVC)
        homeNav.navigationBar.tintColor = Color.colorPrimary

        let menu: MenuVC = drawer.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        
        let drawerController = DrawerVC(drawerDirection: .left, drawerWidth: 300)
        drawerController.mainViewController = homeNav
        drawerController.drawerViewController = menu
        (homeVC as! UITabBarController).selectedIndex = 0
       
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = drawerController
        }
    }
    
    func changeTab(_ index:Int){
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let drawerController = appDelegate.window!.rootViewController as! DrawerVC
        let nc = drawerController.mainViewController as! UINavigationController
        let homeTabC = nc.viewControllers[0] as! HomeTabbarController
        homeTabC.selectedIndex = index
    }
    
    func onShowDetailProduct() {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let drawerController = appDelegate.window!.rootViewController as! DrawerVC
        let nc = drawerController.mainViewController as! UINavigationController
        let homeTabC = nc.viewControllers[0] as! HomeTabbarController
        
        let vc = (UIStoryboard.storyBoard(storyBoard: .Main).instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListVC)
        homeTabC.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openClose(_ isOpen:Bool = false) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController as! DrawerVC
        viewController.setDrawerState(isOpen ? .opened:.closed, animated: true)
    }
    
    func logOut() {
        setLoginAsRoot()
    }
    
    func setLoginAsRoot(){
        let login: UINavigationController = UIStoryboard.storyBoard(storyBoard: .Auth).instantiateInitialViewController() as! UINavigationController
        UIView.appearance().semanticContentAttribute = LocalizationSystem.shared.getLanguage() == "en" ?   .forceLeftToRight : .forceRightToLeft

        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = login
        }
    }
}
