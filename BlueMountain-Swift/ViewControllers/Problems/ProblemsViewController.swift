//
//  ProblemsViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import Alamofire

class ProblemsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeLeft(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        self.revealViewController().panGestureRecognizer().isEnabled = true
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackViewController
        self.navigationController?.setViewControllers([feedbackVC!], animated: true)
    }
    
    func respondToSwipeLeft(sender:UISwipeGestureRecognizer){
        let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackViewController
        
//        let transition = CATransition.init()
//        transition.duration = 0.45
//        transition.type =  kCATransitionReveal
//        self.navigationController?.view.layer.add(transition
//            , forKey: nil)
//        
        self.navigationController?.setViewControllers([feedbackVC!], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CustomNavigationBar.titleText = "Problems"
    }
    
}



