//
//  CustomTabBarController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/18/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import SWRevealViewController

class CustomTabBarController: UITabBarController, SWRevealViewControllerDelegate{
    
    var button1 : UIButton!
    var button2 : UIButton!
    var button3 : UIButton!
    var button4 : UIButton!
    
    var tabButtons : [UIButton]  = []
    let buttonOffImages : [UIImage] = [#imageLiteral(resourceName: "calOff"), #imageLiteral(resourceName: "wasteOff"), #imageLiteral(resourceName: "reportOff"), #imageLiteral(resourceName: "servicesOff")]
    let buttonOnImages : [UIImage] = [#imageLiteral(resourceName: "calOn"), #imageLiteral(resourceName: "wasteOn"), #imageLiteral(resourceName: "reportOn"), #imageLiteral(resourceName: "servicesOn")]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "Location") != nil {
            self.setTabBarItems(withLocationSelected: true)
        }else{
            self.setTabBarItems(withLocationSelected: false)
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
        toggleButtonImages(withIndex: self.selectedIndex)
        
    }
    
    func toggleButtonImages(withIndex index : Int){
        for indexes in 0..<4{
            if(index == indexes){
                tabButtons[indexes].setImage(buttonOnImages[indexes], for: .normal)
            }else{
                tabButtons[indexes].setImage(buttonOffImages[indexes], for: .normal)
            }
        }
        
    }
    
    func setTabBarItems(withLocationSelected isSelected : Bool){
        
//        let wasteMaterialsVC = self.storyboard?.instantiateViewController(withIdentifier: "WasteMaterialsVC") as! WasteMaterialsViewController
//        let problemsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProblemsVC") as! ProblemsViewController
//        let informationVC = self.storyboard?.instantiateViewController(withIdentifier: "InformationVC") as! InformationViewController
        
        let wasteMaterialsNavVC = self.storyboard?.instantiateViewController(withIdentifier: "WasteMaterialsNavVC") as! UINavigationController
        let problemsNavVC = self.storyboard?.instantiateViewController(withIdentifier: "ProblemsNavVC") as! UINavigationController
        let informationNavVC = self.storyboard?.instantiateViewController(withIdentifier: "InformationNavVC") as! UINavigationController
        
        if isSelected {
            //let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarViewController
            let calendarNavVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarNavVC") as! UINavigationController
            //self.setViewControllers([calendarVC, wasteMaterialsVC, problemsVC, informationVC], animated: true)
            self.setViewControllers([calendarNavVC, wasteMaterialsNavVC, problemsNavVC, informationNavVC], animated: true)
        }else{
            //let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "InitialVC") as! InitialViewController
            let initialNavVC = self.storyboard?.instantiateViewController(withIdentifier: "InitialNavVC") as! UINavigationController
            //self.setViewControllers([initialVC, wasteMaterialsVC, problemsVC, informationVC], animated: true)
            self.setViewControllers([initialNavVC, wasteMaterialsNavVC, problemsNavVC, informationNavVC], animated: true)
        }
        
    }
    
}

