//
//  SideBarViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/18/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController {

    
    
    @IBOutlet weak var suburbTextField: UITextField!
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var selectAddressButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suburbTextField.layer.cornerRadius = 20
        streetNameTextField.layer.cornerRadius = 20
        selectAddressButton.layer.cornerRadius = 20
       
        selectAddressButton.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
    }

}
