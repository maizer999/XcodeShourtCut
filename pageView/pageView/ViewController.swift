//
//  ViewController.swift
//  pageView
//
//  Created by Mohammad Abu Maizer on 3/24/19.
//  Copyright © 2019 Mohammad Abu Maizer. All rights reserved.
//


import UIKit
class ViewController: UIViewController
{
    @IBOutlet weak var pageControl: UIPageControl!
    var pageViewController: UIPageViewController?
    var images = ["imperialStarship", "millenniumFalcon", "xwing"]
    var pendinglndex: Int?
    var currentlndex: Int?
    var contentControllers = (ContentViewControllerY)
    override func viewDidLoad() {  super.viewDidLoad()
        self.pageControl.numberOfPages = images.count
        createPageViewController() }
    
    func    createPageViewController() {
        // Instantiate the PageViewController 32
        let pageController = self.storyboard?.instantiateViewController; "pageVC") as! UlPageViewController
        pageController.dataSource = self
        pageController.delegate = self
    }}
