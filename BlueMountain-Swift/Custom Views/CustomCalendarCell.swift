//
//  CustomCalendarCell.swift
//  CustomCalendar
//
//  Created by Prashant Sah on 7/11/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import FSCalendar

class CustomCalendarCell: FSCalendarCell {
    
    @IBOutlet weak var OrganicButton: UIImageView!
    @IBOutlet weak var garbageButton: UIImageView!
    @IBOutlet weak var yellowButton: UIImageView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func draw(_ rect: CGRect) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let selectionLayer = CAShapeLayer()
//        selectionLayer.actions = ["hidden": NSNull()]
//        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
//            self.shapeLayer = selectionLayer
//        
//        buttonsStackView.frame.origin.x = self.frame.size.width/2
//        buttonsStackView.frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height
          }
    
    func configureCell(forDate date : Date) {
        
    }
    
}
