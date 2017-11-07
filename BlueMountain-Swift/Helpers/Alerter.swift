//
//  Alerter.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/24/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import UIKit

class Alerter {
    
    private func presentAlert(withAlertController alertController : UIAlertController)  {
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        if let navVC = rootVC as? UINavigationController{
            let visibleVC = navVC.visibleViewController
            visibleVC?.present(alertController, animated: true, completion: nil)
        }else if let tabVC = rootVC as? UITabBarController{
            let visibletab = tabVC.selectedViewController
            visibletab?.present(alertController, animated: true, completion: nil)
        }else{
            rootVC?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlert(withMessage message : String , alertTitle title : String, alertActions : [UIAlertAction]?){
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        if alertActions != nil{
            for alertAction in alertActions! {
                alertController.addAction(alertAction)
            }
            
        }
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: { (alertAction) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okAction)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "Avenir", size: 18.0)!]
        let messageFont = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 18.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        alertController.view.tintColor = UIColor.black
        //alertController.view.backgroundColor =
        alertController.view.layer.cornerRadius = 20

        presentAlert(withAlertController: alertController)
        
    }
    
}
