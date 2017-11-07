//
//  VisibleController.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 11/7/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import SWRevealViewController

class VisibleController{
    
    func get() -> UIViewController {
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        if let navVC = rootVC as? UINavigationController{
            let visibleVC = navVC.visibleViewController
            return visibleVC!
        }else if let tabVC = rootVC as? UITabBarController{
            let visibletab = tabVC.selectedViewController
            return visibletab!
        }else if let revealVC = rootVC as? SWRevealViewController{
            let revealFrontVC =
                (revealVC.frontViewController as! CustomTabBarController).selectedViewController
            return revealFrontVC!
        }
        else{
            return (rootVC?.presentedViewController)!
        }
    }
}
