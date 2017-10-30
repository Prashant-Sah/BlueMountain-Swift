//
//  InitialViewController.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/30/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var suburbTextField: UITextField!
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var problemLoadingAddressButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureView()
       
    }
    
    func configureView(){
        
        suburbTextField.layer.cornerRadius = 15
        streetNameTextField.layer.cornerRadius = 15
        proceedButton.layer.cornerRadius = 20
        
        let attributes = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 23),
            NSForegroundColorAttributeName : UIColor.black,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
            ] as [String : Any]
        
        let attributeString = NSMutableAttributedString(string: "Problem loading your address?",
                                                        attributes: attributes )
        problemLoadingAddressButton.setAttributedTitle(attributeString, for: .normal)
        problemLoadingAddressButton.addTarget(self, action: #selector(goToProblemsVC), for: .touchUpInside)
        
        
    }
    
    func goToProblemsVC(){
        
        let tabBarController = self.tabBarController as? CustomTabBarController1
        tabBarController?.selectedIndex = 2
        
    }
   
}
