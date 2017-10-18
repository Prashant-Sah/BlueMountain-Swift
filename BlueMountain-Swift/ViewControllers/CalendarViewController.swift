//
//  CalendarViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire
import ObjectMapper

class CalendarViewController : CustomRevealViewController{
    
    enum binTypeId : Int{
        case Garbage = 1
        case Organic
        case Recycling
    }
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var garbageButton: UIButton!
    @IBOutlet weak var organicButton: UIButton!
    @IBOutlet weak var recyclingButton: UIButton!
    @IBOutlet weak var setReminderButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var binPages : [Pages] = []
    var tableViewPages : [Pages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self as? UITableViewDelegate
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarCell")
        
        self.revealViewController().panGestureRecognizer()
        self.setCalendarLayout()
        
        self.binPages = self.getDataFromDatabase().0
        self.tableViewPages = self.getDataFromDatabase().1
        
        if ((self.binPages.count <= 0) || (self.tableViewPages.count <= 0) ){
            self.getBinPagesFromServer()
            self.getTableViewPagesFromServer()
        }else{
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //CustomNavigationBar.titleText = "Waste Info App"
    }
}


// MARK: - Layout for Calendar
extension CalendarViewController{
    
    func setCalendarLayout(){
        self.calendar.collectionViewLayout.interitemSpacing = 0
        self.calendar.collectionView.contentInset = UIEdgeInsets.zero
        
        self.calendar.collectionView.register(UINib(nibName: "CustomCalendarCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        if let layout = self.calendar.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets.zero
            layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
    }
    
    
}

// MARK: - FSCalendarDataSource, FSCalendarDelegate functions
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


// MARK: - FSCalendarDelegateAppearance functions
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


// MARK: - Button Handlers
extension CalendarViewController {
    
    @IBAction func stackButtonsPressed(sender : UIButton){
        
        if(sender.tag != 0 && sender.tag <= 3){
            self.getPageFromDatabase(withBinColor: sender.tag)
        }else{
            print("set Reminder Arey :D ")
        }
    }
    
    func getPageFromDatabase(withBinColor binColorId : Int ){
        
        //let index = self.binPages.index { (page) -> Bool in
            //page.binTypeId == binColorId
            //page.pageTitle == "ORGANIC"
        //}
        let index = 2
        self.passPageToPageDetailsVC(withPage: self.binPages[index])
        
        let query = "Select * from pages where section_id = 3 and bin_color_id = \(binColorId)"
        self.passPageToPageDetailsVC(withPage: (DBManager.sharedInstance.getPagesFromDatabase(withQuery: query)?.first)!)
        
    }
        @IBAction func garbageButtonClicked(_ sender: UIButton) {
    
            let index = self.binPages.index { (page) -> Bool in
                page.pageTitle == "GARBAGE"
            }
            if(index != nil){
            self.passPageToPageDetailsVC(withPage: self.binPages[index!])
            }
        }
    
        @IBAction func organicButtonClicked(_ sender: UIButton) {
            let index = self.binPages.index { (page) -> Bool in
                page.pageTitle == "ORGANIC"
            }
            if(index != nil){
                self.passPageToPageDetailsVC(withPage: self.binPages[index!])
            }
        }
    
        @IBAction func recyclingButtonClicked(_ sender: UIButton) {
            let index = self.binPages.index { (page) -> Bool in
                page.pageTitle == "RECYCLING"
            }
            if(index != nil){
                self.passPageToPageDetailsVC(withPage: self.binPages[index!])
            }
        }
    
    
        @IBAction func setReminderButtonClicked(_ sender: UIButton) {
        }
    
    
}

// MARK: - UITableViewDataSource functions
extension CalendarViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewPages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath)
        cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "rightBut"))
        cell.textLabel?.font = UIFont(name: "Avenir", size: 22)
        cell.textLabel?.text = self.tableViewPages[indexPath.row].pageTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


// MARK: - UITableViewDelegate functions
extension CalendarViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.passPageToPageDetailsVC(withPage: self.tableViewPages[indexPath.row])
    }
}


// Presenting PageDetailsViewController
extension CalendarViewController {
    
    func passPageToPageDetailsVC(withPage page : Pages){
        
        let pageDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "PageDetailsViewController") as? PageDetailsViewController
        pageDetailsVC?.receivedPage = page
        self.navigationController?.pushViewController(pageDetailsVC!, animated: true)
    }
}

// MARK: - Get data from server or database
extension CalendarViewController {
    
    func getBinPagesFromServer() {
        
        let getPagesBySectionIdURL = "\(BASE_URL.appending(GET_PAGES_BY_SECTION_ID_PATH))"
        
        let param = [
            "section_id" : "3",
            "calendar_other" : "1"
        ]
        
        Alamofire.request(getPagesBySectionIdURL, method: .post, parameters: param).responseJSON(completionHandler: { [weak self] response in
            
            guard let sSelf = self  else {
                return
            }
            
            let obtainedResponse = response.result.value as! Dictionary<String,Any>

            let data = obtainedResponse["pages"] as! NSArray
            let dict = data.firstObject
            sSelf.binPages = Mapper<Pages>().mapArray(JSONObject: data)!
            
            for page in sSelf.binPages {
                print(page.pageTitle!)
            }
            DBManager.sharedInstance.pushPagesToDatabase(withArray: sSelf.binPages)
        })
        
    }
    
    func getTableViewPagesFromServer(){
        
        
        let getPagesBySectionIdURL = "\(BASE_URL.appending(GET_PAGES_BY_SECTION_ID_PATH))"
        
        let param = [
            "section_id" : "3",
            "calendar_other" : "2"
        ]
        
        Alamofire.request(getPagesBySectionIdURL, method: .post, parameters: param).responseJSON(completionHandler: { [weak self] response in
            
            guard let sSelf = self  else {
                return
            }
            
            let obtainedResponse = response.result.value as! Dictionary<String, Any>
            
            let data = obtainedResponse["pages"] as! NSArray
            
            sSelf.tableViewPages = Mapper<Pages>().mapArray(JSONObject: data)!
            
            for page in sSelf.tableViewPages {
                print(page.pageTitle!)
            }
            DBManager.sharedInstance.pushPagesToDatabase(withArray: sSelf.tableViewPages)
            sSelf.tableView.reloadData()
        })
    }
    
    func getDataFromDatabase() -> ([Pages],[Pages]){
        
        var query = "Select * from pages where section_id = 3 and type_of_calendar = 1"
        let binPagesFromDB = DBManager.sharedInstance.getPagesFromDatabase(withQuery: query)!
        
        query = "Select * from pages where section_id = 3 and type_of_calendar = 2"
        let tableViewPagesFromDB = DBManager.sharedInstance.getPagesFromDatabase(withQuery: query)!
        
        return (binPagesFromDB, tableViewPagesFromDB)
    }
    
}
