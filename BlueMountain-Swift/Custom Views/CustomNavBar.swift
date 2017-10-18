//
//  CustomNavBar.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit

class CustomNavBar: UIView {
    
    enum NavButtonType : Int {
        case menu = 1
        case back = 2
    }
    
    @IBOutlet weak var leftBarButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightSideImageView: UIImageView!
    
    /// Initializer with frame
    ///
    /// - Parameter frame: CGRect() for frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadNavBar(withTitle title : String , ButtonType : Int){
        
        self.titleLabel.text = title
        switch ButtonType {
        case NavButtonType.menu.rawValue:
            self.leftBarButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
            break
        case NavButtonType.back.rawValue :
            self.leftBarButton.setImage(#imageLiteral(resourceName: "leftBut"), for: .normal)
            break
        default:
            self.leftBarButton.setImage(nil, for: .normal)
            break
        }
    }
    
    
    
    private func loadView() {
        
        
    }
    
    
    
    
}
