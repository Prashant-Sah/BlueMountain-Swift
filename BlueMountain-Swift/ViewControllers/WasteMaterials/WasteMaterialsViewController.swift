//
//  WasteMaterialsViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class WasteMaterialsViewController: CustomRevealViewController {
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    var pages : [Pages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "WasteMaterialsTableViewCell", bundle: nil) ,forCellReuseIdentifier: "WasteCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        self.revealViewController().panGestureRecognizer()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(deActivateRevealAction) , name: locationSelectedNotificationKey, object: nil)
    }
    
    
    func refresh() {
        getDataFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !(pages.count > 0){
            let query = "Select * from pages where section_id = 2"
            let pagesFromDB = DBManager.sharedInstance.getPagesFromDatabase(withQuery: query)
            
            if(pagesFromDB?.count == 0){
                getDataFromServer()
            }else{
                pages = pagesFromDB!
                self.tableView.reloadData()
            }
        }
        
        CustomNavigationBar.titleText = "Materials"
    }
}



// MARK: - Get wasteMaterials from server
extension WasteMaterialsViewController {
    
    func getDataFromServer() {
        
        let param = [
            "bin_type" : "0"
        ]
        APICaller().getWasteMaterials(withParameters: param, withIndicatorMessage: "Getting Waste Materials from server") { (list) in
            
            self.refreshControl.endRefreshing()
            self.pages = Mapper<Pages>().mapArray(JSONObject: list)!
            self.tableView.reloadData()
            DBManager.sharedInstance.pushPagesToDatabase(withArray: self.pages)
            
        }
        
    }
}

// MARK: - UITableViewDataSource functions
extension WasteMaterialsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WasteCell", for: indexPath) as? WasteMaterialsTableViewCell {
            cell.configureView(withPage: self.pages[indexPath.row] )
            return cell
        }else{
            return WasteMaterialsTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


// MARK: - UITableViewDelegate functions
extension WasteMaterialsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pageDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "PageDetailsViewController") as? PageDetailsViewController
        
        pageDetailsVC?.receivedPage = self.pages[indexPath.row]
        self.navigationController?.pushViewController(pageDetailsVC!, animated: true)
    }
}


extension WasteMaterialsViewController{
    
    func deActivateRevealAction(){
        
        self.revealViewController().panGestureRecognizer().isEnabled = false
        
    }
}
