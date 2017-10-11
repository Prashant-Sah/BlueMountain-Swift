//
//  CalendarViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import FSCalendar
import SWRevealViewController

class CalendarViewController : CustomRevealViewController{
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var garbageButton: UIButton!
    @IBOutlet weak var organicButton: UIButton!
    @IBOutlet weak var recyclingButton: UIButton!
    @IBOutlet weak var setReminderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomNavigationBar.titleText = "Waste Info App"
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.calendar.collectionViewLayout.interitemSpacing = 0
        self.calendar.collectionView.contentInset = UIEdgeInsets.zero
        
        self.calendar.collectionView.register(UINib(nibName: "CustomCalendarCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        if let layout = self.calendar.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets.zero
            layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
        
        self.revealViewController().panGestureRecognizer()
    }
    
}


extension CalendarViewController : FSCalendarDataSource, FSCalendarDelegate{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: monthPosition) as? CustomCalendarCell
        cell?.backgroundImageView.image = #imageLiteral(resourceName: "highlightedButton")
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        if let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position) as? CustomCalendarCell {
            return cell
        }
        return FSCalendarCell()
        
    }
    
}

extension CalendarViewController : FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor.clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        
        appearance.borderRadius = 0
        //return Colors().hexStringToUIColor(hex:"#C6D3A6")
        return UIColor.clear
    }
    
}
