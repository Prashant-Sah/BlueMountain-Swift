//
//  CustomRevealViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/18/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import SWRevealViewController

class CustomRevealViewController: UIViewController, SWRevealViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealViewController : SWRevealViewController = self.revealViewController()
        revealViewController.delegate = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        revealViewController.rearViewRevealWidth = 340
        revealViewController.rearViewRevealOverdraw = 0
        self.revealViewController().panGestureRecognizer()
        
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


