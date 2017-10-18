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
    @IBOutlet weak var nextCollectionButton: UIButton!
    @IBOutlet weak var allCollectionButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    
    var nextCollectionChecked : Bool = false
    var allCollectionChecked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suburbTextField.layer.cornerRadius = 20
        streetNameTextField.layer.cornerRadius = 20
        selectAddressButton.layer.cornerRadius = 20
        setButton.layer.cornerRadius = 20
        
        selectAddressButton.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        setButton.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
    }
}



// MARK: - Button Handlers
extension SideBarViewController {
    
    @IBAction func selectButtonClicked(_ sender: UIButton) {
    }
    @IBAction func setButtonClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func nextCollectionButtonClicked(_ sender: UIButton) {
        nextCollectionChecked = !(nextCollectionChecked)
        if(nextCollectionChecked){
        nextCollectionButton.setImage(#imageLiteral(resourceName: "newTickButOn"), for: .normal)
        }else{
            nextCollectionButton.setImage(#imageLiteral(resourceName: "newTickBut"), for: .normal)
        }
    }
    @IBAction func allCollectionButtonClicked(_ sender: UIButton) {
        allCollectionChecked = !(allCollectionChecked)
        if(allCollectionChecked){
            allCollectionButton.setImage(#imageLiteral(resourceName: "newTickButOn"), for: .normal)
        }else{
            allCollectionButton.setImage(#imageLiteral(resourceName: "newTickBut"), for: .normal)
        }
    }
    
    
}
