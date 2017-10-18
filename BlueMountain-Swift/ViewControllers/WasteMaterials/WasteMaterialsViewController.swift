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
    
    @IBOutlet weak var tableView: UITableView!
    
    var pages : [Pages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "WasteMaterialsTableViewCell", bundle: nil) ,forCellReuseIdentifier: "WasteCell")
        
        self.revealViewController().panGestureRecognizer()
        
        let query = "Select * from pages where section_id = 2"
        let pagesFromDB = DBManager.sharedInstance.getPagesFromDatabase(withQuery: query)
        
        if(pagesFromDB?.count == 0){
            self.getDataFromServer()
        }else{
            pages = pagesFromDB!
            self.tableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //CustomNavigationBar.titleText = "Materials"
    }
}



// MARK: - Get wasteMaterials from server
extension WasteMaterialsViewController {
    
    func getDataFromServer() {
        
        let wasteMaterialsURL = "\(BASE_URL.appending(WASTE_MATERAILS_PATH))"
        
        let param = [
            "bin_type" : "0"
        ]
        
        Alamofire.request(wasteMaterialsURL, method: .post, parameters: param).responseJSON(completionHandler: { [weak self] response in
            
            guard let sSelf = self  else {
                return
            }
            
            let obtainedResponse = response.result.value as! Dictionary<String, Any>
            
            let wasteMaterialsData = obtainedResponse["list"] as! NSArray
            
            sSelf.pages = Mapper<Pages>().mapArray(JSONObject: wasteMaterialsData)!
            
            for page in sSelf.pages {
                print(page.pageTitle!)
            }
            sSelf.tableView.reloadData()
            DBManager.sharedInstance.pushPagesToDatabase(withArray: sSelf.pages)
            
        })

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
