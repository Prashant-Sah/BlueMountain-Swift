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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().panGestureRecognizer()
        
        
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
            print(wasteMaterialsData[0])
            //let page = Mapper<Pages>().mapDictionary(JSONObject: wasteMaterialsData[0])
//            for data in (wasteMaterialsData) {
//                let page = Mapper<Pages>().map(JSONObject:data)
//                
//            }
            let pages = Mapper<Pages>().mapArray(JSONObject: wasteMaterialsData)
            
            for page in pages!{
                print(page.pageTitle!)
            }
            
            DBManager.sharedInstance.pushPagesToDatabase(withArray: pages!)
            //DBManager.sharedInstance.pushPagesToDatabase(withArray: (wasteMaterialsData as? [Pages])!)
            print(pages?[23].pageTitle! as Any)
            sSelf.tableView.reloadData()
            
        })
        
    }
    
    
    
    
    
}
