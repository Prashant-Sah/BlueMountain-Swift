//
//  ProblemsViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import Alamofire

class ProblemsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomNavigationBar.titleText = "Report Problem"

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeLeft(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        self.revealViewController().panGestureRecognizer().isEnabled = true
        
        //let problemsPathURL = URL(string: BASE_URL.appending(PROBLEMS_PATH))
        
        //        let problemsPathURL = "http://ci.draftserver.com/bluemountainapp/webservice/get_updated_data"
        //
        //        Alamofire.request(problemsPathURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
        //
        //            print(response)
        //            print(response.data!)
        //        }
        //
        //        Alamofire.request(problemsPathURL).responseData(completionHandler: { (response) in
        //            print(response)
        //            print(response.data!)
        //        })
        
        
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackViewController
        //self.navigationController?.pushViewController(feedbackVC!, animated: true)
        self.navigationController?.setViewControllers([feedbackVC!], animated: true)
    }
    
    func respondToSwipeLeft(sender:UISwipeGestureRecognizer){
        let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackViewController
        self.navigationController?.setViewControllers([feedbackVC!], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let wasteMaterialsURL = "\(BASE_URL.appending(WASTE_MATERAILS_PATH))"
        
        let param = [
            "bin_type" : "0"
        ]
        
        Alamofire.request(wasteMaterialsURL, method: .post, parameters: param).responseJSON(completionHandler: { [weak self] response in
            
            guard let sSelf = self  else {
                return
            }
            print(response.data!)
            print(response.result.value)
            
            
        })

    }

}

