//
//  ProblemsViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit

class ProblemsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var contactMeButton: UIButton!
    var canContactMe = false
    
    var feedbackInfo : FeedbackInfo?
    var userInfo : UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeLeft(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        self.revealViewController().panGestureRecognizer().isEnabled = true
        
        if (self.userInfo != nil){
            self.nameTextField.text = self.userInfo?.name
            self.emailTextField.text = self.userInfo?.email
            self.phoneTextField.text = self.userInfo?.phone
            self.canContactMe = (self.userInfo?.canBeContacted)!
            self.contactMeButton.setImage((self.userInfo?.canBeContacted)! ? #imageLiteral(resourceName: "newTickButOn") : #imageLiteral(resourceName: "newTickBut"), for: .normal)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CustomNavigationBar.titleText = "Problems"
    }
}


// MARK: - Button and Swipe Action Handlers
extension ProblemsViewController{
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.moveToFeedbackPage()
    }
    
    func respondToSwipeLeft(sender:UISwipeGestureRecognizer){
        //let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackViewController
        //        let transition = CATransition.init()
        //        transition.duration = 0.45
        //        transition.type =  kCATransitionReveal
        //        self.navigationController?.view.layer.add(transition
        //            , forKey: nil)
        //
        //self.navigationController?.setViewControllers([feedbackVC!], animated: true)

        self.moveToFeedbackPage()
    }
    
    @IBAction func contactMeButtonPressed(_ sender: UIButton){
        
        canContactMe = !canContactMe
        if(canContactMe){
            self.contactMeButton.setImage(#imageLiteral(resourceName: "newTickButOn"), for: .normal)
        }else{
            self.contactMeButton.setImage(#imageLiteral(resourceName: "newTickBut"), for: .normal)
        }
    }
}

extension ProblemsViewController{
    
    func moveToFeedbackPage(){
        
        let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackViewController
        
        self.userInfo = UserInfo(self.nameTextField.text, email: self.emailTextField.text, phone: self.phoneTextField.text, canBeContacted: canContactMe)
        feedbackVC?.userInfo = self.userInfo
        if (feedbackInfo != nil){
            feedbackVC?.feedbackInfo = self.feedbackInfo
        }
        
        self.navigationController?.setViewControllers([feedbackVC!], animated: true)
        //self.navigationController?.pushViewController(feedbackVC!, animated: true)
        
    }
}


