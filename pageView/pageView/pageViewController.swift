//
//  pageViewController.swift
//  pageView
//
//  Created by Mohammad Abu Maizer on 3/24/19.
//  Copyright © 2019 Mohammad Abu Maizer. All rights reserved.
//

import UIKit

class pageViewController: UIViewController {
    
    @IBOutlet weak var PageControl: UIPageControl!
    
    var pageViewController: UIPageViewController?
    var images = ["book1page1.png","book1","book1","book1page2.png","book1page1.png","book1page2.png"]
    var pendingIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
        setupPageControll()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createPageViewController() {
        // Instantiate the PageViewController
        let pageController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        pageController.dataSource = self
        pageController.delegate = self
        
        if images.count > 0{
            let firstController = getContentViewController(withIndex: 0)!
            let contentControllers = [firstController]
            
            pageController.setViewControllers(contentControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
        }
        
        pageViewController = pageController
        
        self.addChildViewController(pageViewController!)
        
        //self.view.addSubview(pageViewController!.view)
        self.view.insertSubview(pageViewController!.view, at: 0)
        pageViewController!.didMove(toParentViewController: self)
        
    }
    
    //Setup Pagination Icons and count
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return images.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func setupPageControll(){
        let apperance = UIPageControl.appearance()
        apperance.pageIndicatorTintColor = UIColor.gray
        apperance.currentPageIndicatorTintColor = UIColor.white
        apperance.backgroundColor = UIColor.clear
    }
    
    func currentControllerIndex() -> Int{
        let pageItemController = self.currentConroller()
        
        if let controller = pageItemController as? ContentViewController {
            return controller.itemIndex
        }
        return -1
    }
    
    ///////////////////////////////////////////////
    
    func currentConroller() -> UIViewController?{
        if (self.pageViewController?.viewControllers?.count)! > 0{
            return self.pageViewController?.viewControllers![0]
        }
        
        return nil
    }
    
    func getContentViewController(withIndex index: Int) -> ContentViewController? {
        if index < images.count{
            let contentVC = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
            contentVC.itemIndex = index
            contentVC.imageName = images[index]
            
            return contentVC
        }
        
        return nil
    }
    
}

extension pageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = (pendingViewControllers.first as! ContentViewController).itemIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentIndex = pendingIndex
            if let index = currentIndex {
                self.PageControl.currentPage = index
            }
            
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentViewController
        if contentVC.itemIndex > 0 {
            return getContentViewController(withIndex: contentVC.itemIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentViewController
        if contentVC.itemIndex + 1 < images.count {
            return getContentViewController(withIndex: contentVC.itemIndex + 1)
        }
        
        return nil
    }
}
