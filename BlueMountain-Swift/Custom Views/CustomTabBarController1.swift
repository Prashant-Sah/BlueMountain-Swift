//
//  CustomTabBarController1.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/18/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import SWRevealViewController

class CustomTabBarController1: UITabBarController, SWRevealViewControllerDelegate{
    
    var button1 : UIButton!
    var button2 : UIButton!
    var button3 : UIButton!
    var button4 : UIButton!
    
    var tabButtons : [UIButton]  = []
    let buttonOffImages : [UIImage] = [#imageLiteral(resourceName: "calOff"), #imageLiteral(resourceName: "wasteOff"), #imageLiteral(resourceName: "reportOff"), #imageLiteral(resourceName: "servicesOff")]
    let buttonOnImages : [UIImage] = [#imageLiteral(resourceName: "calOn"), #imageLiteral(resourceName: "wasteOn"), #imageLiteral(resourceName: "reportOn"), #imageLiteral(resourceName: "servicesOn")]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        let wasteMaterialsVC = self.storyboard?.instantiateViewController(withIdentifier: "WasteMaterialsVC") as! WasteMaterialsViewController
        let problemsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProblemsVC") as! ProblemsViewController
        let informationVC = self.storyboard?.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomTabBarController1.setTabBarItemsBasedOnLocation) , name: locationSelectedNotificationKey , object: nil)
        
        if UserDefaults.standard.value(forKey: "Location") != nil {
             let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
            self.setViewControllers([calendarVC, wasteMaterialsVC, problemsVC, informationVC], animated: true)
            
        }else{
            let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "InitialVC") as! InitialViewController
            self.setViewControllers([initialVC, wasteMaterialsVC, problemsVC, informationVC], animated: true)

        }
        
        self.setTabBarButtons()
        
    }
    
    func setTabBarButtons(){
        
        let tabBarView = UIView(frame: CGRect.zero)
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 130 : 90
        tabBarView.frame = CGRect(x: 0, y: self.view.bounds.size.height - height, width: self.view.bounds.size.width, height: height)
        tabBarView.backgroundColor = UIColor.blue
        self.view.addSubview(tabBarView)
        
        let widthOfEachButton : Int = (Int)(self.view.bounds.size.width)/4
        
        var buttonImages : [UIImage] = [buttonOnImages[0]]
        buttonImages.append(contentsOf: buttonOffImages[1...3])
        
        for index in 0..<4 {
            
            let btn = UIButton(type: .custom)
            
            btn.tag = index
            btn.frame = CGRect(x: widthOfEachButton*index, y: 0, width: widthOfEachButton, height: Int(height))
            btn.contentHorizontalAlignment = .fill
            btn.contentVerticalAlignment = .fill
            btn.setImage(buttonImages[index], for: .normal)
            btn.addTarget(self, action: #selector(goToViewControllers(sender:)) , for: .touchDown)
            tabBarView.addSubview(btn)
            tabButtons.append(btn)
        }
        
        
        self.view.layer.shadowOpacity = 0.75;
        self.view.layer.shadowRadius = 10.0;
        self.view.layer.shadowColor = UIColor.black.cgColor
        
        self.selectedIndex = 0
        
    }
    
    
    func goToViewControllers(sender : UIButton){
        
        self.selectedIndex = sender.tag
        
        for index in 0..<4{
            if(sender.tag == index){
                tabButtons[index].setImage(buttonOnImages[index], for: .normal)
            }else{
                tabButtons[index].setImage(buttonOffImages[index], for: .normal)
            }
        }
    }
    
    func setTabBarItemsBasedOnLocation(){
        
        let wasteMaterialsVC = self.storyboard?.instantiateViewController(withIdentifier: "WasteMaterialsVC") as! WasteMaterialsViewController
        let problemsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProblemsVC") as! ProblemsViewController
        let informationVC = self.storyboard?.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
        let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "InitialVC") as! InitialViewController
        self.setViewControllers([initialVC, wasteMaterialsVC, problemsVC, informationVC], animated: true)
    }
    
    
}

