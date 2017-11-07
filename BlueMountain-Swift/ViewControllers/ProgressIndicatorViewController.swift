//
//  ProgressIndicatorViewController.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 11/7/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit

class ProgressIndicatorViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var actvityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var displayMessage: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var message : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bgView.backgroundColor =
        topConstraint.constant = UIDevice.current.model.hasPrefix("iPad") ? 64 : 44
        bottomConstraint.constant = UIDevice.current.model.hasPrefix("iPad") ? 130 : 90

        actvityIndicator.backgroundColor = UIColor.lightGray
        actvityIndicator.activityIndicatorViewStyle = .whiteLarge
        actvityIndicator.startAnimating()
        
        if message != nil{
            displayMessage.text = message
        }else{
            displayMessage.text = "Gathering Required Information"
        }
        
    }
    
    func showIndicator(withMessage msg : String?){
        if msg != nil{
            displayMessage.text = msg
        }else{
            displayMessage.text = "Gathering Required Information"
        }
    }
    
    func hideIndicator(){
        self.dismiss(animated: true, completion: nil)
    }

   
}
