//
//  InformationViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class InformationViewController: CustomRevealViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var pages : [Pages] = []
    var sections : [Sections] = []
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InfoCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SectionsCell")
        
        if (self.pages.isEmpty == true){
            
            let query = "Select * from pages where section_id in (1,5)"
            let pagesFromDB = DBManager.sharedInstance.getPagesFromDatabase(withQuery: query)
            
            if (pagesFromDB?.isEmpty == true){
                
                self.getPagesFromServer(withSectionIds: [1,5])
                
            } else{
                self.getRequiredDataFromDatabase()
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // CustomNavigationBar.titleText = "More-Info"
    }
    
    func getRequiredDataFromDatabase(){
        var query = "Select * from pages where section_id = 1"
        self.pages = DBManager.sharedInstance.getPagesFromDatabase(withQuery: query)!
        
        query = "Select * from sections where section_id = 5"
        self.sections = DBManager.sharedInstance.getSectionsFromDatabase(withQuery: query)
        
    }
}


// MARK: - Get data from server
extension InformationViewController {
    
    func getPagesFromServer(withSectionIds section_ids : [Int]) {
        
        let getPagesBySectionIdURL = "\(BASE_URL.appending(GET_PAGES_BY_SECTION_ID_PATH))"
        
        for section_id in section_ids{
            
            dispatchGroup.enter()
            
            let param = [
                "section_id" : section_id
            ]
            
            Alamofire.request(getPagesBySectionIdURL, method: .post, parameters: param).responseJSON(completionHandler: { [weak self] response in
                
                guard let sSelf = self  else {
                    return
                }
                
                let obtainedResponse = response.result.value as! Dictionary<String, Any>
                
                let moreInfoData = obtainedResponse["pages"] as! [[String:Any]]
                
                for data in moreInfoData{
                    let id = data["page_id"]
                    sSelf.getDetailsPageFromServer(withPageId: id as! String)
                }
                
                let moreInfoSections = obtainedResponse["sections"] as! [[String:Any]]
                for section in moreInfoSections{
                    let nSection = Mapper<Sections>().map(JSONObject: section)
                    DBManager.sharedInstance.pushSingleSectionToDatabase(withSection: nSection!)
                }
                sSelf.dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.getRequiredDataFromDatabase()
            self.tableView.reloadData()
        }
    }
    
    func getDetailsPageFromServer(withPageId page_id : String) {
        
        self.dispatchGroup.enter()
        let getPageDetailsURL = "\(BASE_URL.appending(GET_PAGES_DETAILS_PATH))"
        let param = [
            "page_id" : page_id
        ]
        
        Alamofire.request(getPageDetailsURL, method: .post, parameters: param).responseJSON(completionHandler: {  response in
            
            let obtainedData = response.result.value as? [String : Any]
            let obtainedPage = obtainedData?["page_detail"]
            if let page = Mapper<Pages>().map(JSONObject: obtainedPage) {
                if(page.sectionId != "5"){
                    self.pages.append(page)
                }
                DBManager.sharedInstance.pushSinglePageToDatabase(withPage: page)
                self.dispatchGroup.leave()
            }
        })
    }
    
}



// MARK: - TableViewDataSource functions
extension InformationViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pages.count + self.sections.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row < self.pages.count){
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
            cell.textLabel?.font = UIFont(name: "Avenir", size: 22)
            cell.textLabel?.text = self.pages[indexPath.row].pageTitle
            return cell
        }else{
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SectionsCell", for: indexPath)
            cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "rightBut"))
            cell.textLabel?.font = UIFont(name: "Avenir", size: 22)
            cell.textLabel?.text = self.sections[indexPath.row - self.pages.count].title
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


//
// MARK: - TableView Delegate functions
extension InformationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row < self.pages.count){
            
            let pageDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "PageDetailsViewController") as? PageDetailsViewController
            pageDetailsVC?.receivedPage = self.pages[indexPath.row]
            self.navigationController?.pushViewController(pageDetailsVC!, animated: true)
        }else{
            
            let moreInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "InformationViewController") as? InformationViewController
            let query = "Select * from pages where section_id = 5"
            let sectionPages = DBManager.sharedInstance.getPagesFromDatabase(withQuery: query)!
            moreInfoVC?.pages = sectionPages
            self.navigationController?.pushViewController(moreInfoVC!, animated: true)
        }
        
    }
}
