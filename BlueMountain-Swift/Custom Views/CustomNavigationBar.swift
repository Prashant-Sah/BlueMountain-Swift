//
//  CustomNavigationBar.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/18/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit


class CustomNavigationBar: UINavigationBar {
    
    
    static var titleText : String?
    
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
        
        let menuButton : UIButton = UIButton(frame: CGRect(x: 10, y: 20, width: 40, height: 40))
        menuButton.setBackgroundImage(#imageLiteral(resourceName: "settings"), for: .normal)
        menuButton.contentMode = .scaleAspectFill
        navBar.addSubview(menuButton)
        
        
        
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
