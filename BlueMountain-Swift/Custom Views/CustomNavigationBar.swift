//
//  CustomNavigationBar.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/18/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import SWRevealViewController

class CustomNavigationBar: UINavigationBar{
    
    enum NavigationButtonType : Int {
        case menu = 1
        case back = 2
    }
    
    static var titleText : String?
    var buttonType : Int?
    var leftButton = UIButton()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let navBarHeight: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 84 : 74
        let navBar : UIView = UIView(frame: CGRect(x: 0, y: 0, width: (self.superview?.bounds.size.width)!, height: navBarHeight))
        
        self.superview?.addSubview(navBar)
        
        let navBarImageView = UIImageView(frame: navBar.frame)
        navBarImageView.image = #imageLiteral(resourceName: "navBar")
        navBarImageView.contentMode = .scaleAspectFill
        navBar.addSubview(navBarImageView)
        
        leftButton = UIButton(frame: CGRect(x: 10, y: 20, width: 40, height: 40))
        
        self.buttonType = self.buttonType ?? NavigationButtonType.menu.rawValue
        
        switch self.buttonType! {
            
        case NavigationButtonType.menu.rawValue:
            leftButton.setBackgroundImage(#imageLiteral(resourceName: "settings"), for: .normal)
            let revealViewController = SWRevealViewController().revealViewController()
            leftButton.addTarget(revealViewController, action: #selector(revealViewController?.revealToggle(_:)), for: .touchUpInside)
            break
        case NavigationButtonType.back.rawValue:
            leftButton.setBackgroundImage(#imageLiteral(resourceName: "leftBut"), for: .normal)
            leftButton.addTarget(self.window?.rootViewController?.presentingViewController, action: #selector(PageDetailsViewController.backButtonClicked) , for: .touchUpInside)
        default:
            break
        }
        leftButton.contentMode = .scaleAspectFill
        navBar.addSubview(leftButton)
        
        
        //Put title logo
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        titleLabel.center = CGPoint(x: navBar.center.x, y: navBar.center.y)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.font = titleLabel.font.withSize(22)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = CustomNavigationBar.titleText
        titleLabel.textColor = UIColor.white
        navBar.addSubview(titleLabel)
        
        
        //Put council logo
        
        let councilLogoImageView = UIImageView(frame: CGRect(x: 0 , y: 0, width: 80, height: 50))
        councilLogoImageView.center = CGPoint(x: navBar.frame.size.width - (councilLogoImageView.frame.size.width/2), y: navBar.center.y)
        councilLogoImageView.image = #imageLiteral(resourceName: "councilLogo_blue")
        councilLogoImageView.contentMode = UIViewContentMode.scaleAspectFill
        navBar.addSubview(councilLogoImageView)
        
    }
    
    
}


