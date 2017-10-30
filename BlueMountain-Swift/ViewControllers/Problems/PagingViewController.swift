//
//  PagingViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/25/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import SWRevealViewController

class PagingViewController: UIPageViewController, SWRevealViewControllerDelegate {
    
    let orderedViewControllers : [UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "ProblemsVC") as! ProblemsViewController
        let vc2 = sb.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackViewController
        return [vc1,vc2]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        revealViewController().panGestureRecognizer().isEnabled = true
        
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBar"), for: UIBarMetrics.default)
        
        let leftBarButton : UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: revealViewController, action: #selector(self.revealViewController().revealToggle(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        revealViewController().rearViewRevealOverdraw = 0
        
        
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if (position == FrontViewPosition.left){
            revealController.frontViewController.view.isUserInteractionEnabled = true
        }else{
            revealController.frontViewController.view.isUserInteractionEnabled = false
            revealController.frontViewController.revealViewController().tapGestureRecognizer()
        }
    }
}

// MARK: UIPageViewControllerDataSource
extension PagingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        
        if (previousIndex < viewControllerIndex && !(previousIndex < 0)){
            return orderedViewControllers[previousIndex]
        }else{
            return nil //orderedViewControllers[viewControllerIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        if(nextIndex < orderedViewControllersCount){
            return orderedViewControllers[nextIndex]
        }else{
            return nil //orderedViewControllers[viewControllerIndex]
        }
    }
    
}



