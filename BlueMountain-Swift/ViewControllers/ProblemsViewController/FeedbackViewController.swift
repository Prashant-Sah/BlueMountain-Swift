//
//  FeedbackViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/25/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var feedbackTopicTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var feedbackTextView: UITextView!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().panGestureRecognizer().isEnabled = false
        
        self.navigationItem.setHidesBackButton(true, animated: false)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeRight(sender:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        feedbackTopicTextField.placeholder = "Choose a Topic"
        locationTextField.placeholder = "Location"
        feedbackTextView.text = "Notes"
        feedbackTextView.textColor = UIColor.lightGray
        feedbackTopicTextField.layer.cornerRadius = 15
        locationTextField.layer.cornerRadius = 15
        feedbackTextView.layer.cornerRadius = 15
        sendButton.layer.cornerRadius = 15

        let locateBut = UIButton(type: .custom)
        locateBut.frame =  CGRect(x: self.locationTextField.frame.size.width - 35, y: 5, width: 30, height: 30)
        locateBut.setBackgroundImage(#imageLiteral(resourceName: "locateBut"), for: .normal)
        locateBut.addTarget(self, action: #selector(locateButtonPressed), for: .touchUpInside)
        locationTextField.rightViewMode = UITextFieldViewMode.always ;
        locationTextField.rightView = locateBut;   
    }
    
    func respondToSwipeRight(sender:UISwipeGestureRecognizer){
        
        let problemsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProblemsVC") as? ProblemsViewController
        
        let transition = CATransition.init()
        transition.duration = 0.45
        transition.type =  kCATransitionReveal
        self.navigationController?.view.layer.add(transition
            , forKey: nil)
        self.navigationController?.setViewControllers([problemsVC!], animated: false)
    }
    
    func locateButtonPressed (){
        print("Pressed")
    }
    

}
