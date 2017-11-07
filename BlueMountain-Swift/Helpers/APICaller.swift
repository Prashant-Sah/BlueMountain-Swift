//
//  APICaller.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/20/17.
//  Copyright © 2017  Prashant Sah. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class APICaller {
    
    /// <#Description#>
    ///
    /// - Parameter msg: <#msg description#>
    func showIndicator(withMessage msg : String){
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                
                let visible = VisibleController().get()
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let indicator = mainStoryBoard.instantiateViewController(withIdentifier: "ProgressIndicatorVC") as? ProgressIndicatorViewController
                indicator?.message = msg
                
                indicator?.modalPresentationStyle = .custom
                indicator?.modalTransitionStyle = .crossDissolve
                
                visible.present(indicator!, animated: true, completion: nil)
            }
        }
    }
    
    
    /// <#Description#>
    func hideIndicator(){
        
        let visible = VisibleController().get()
        visible.dismiss(animated: true, completion: nil)
        
    }

    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - dataResponse: <#dataResponse description#>
    ///   - contentValues: <#contentValues description#>
    ///   - completion: <#completion description#>
    func handleResponse(withResponse dataResponse : DataResponse<Any>,lookFor contentValues:[String], completion : (_ result : [Any]) -> () ){
        
        let result = dataResponse.result
        switch result {
        case .success(let value):
            print("got a response")
            if let responseValue = value as? [String : Any]{
                if (responseValue["code"] as! String == SUCCESS){
                    var resultArray = [Any]()
                    for contentValue in contentValues{
                        resultArray.append(responseValue[contentValue]!)
                    }
                    hideIndicator()
                    completion(resultArray)
                }else{
                    hideIndicator()
                    Alerter().showAlert(withMessage: responseValue["msg"] as! String, alertTitle: "Error", alertActions: nil)
                }
            }
            break
        case .failure(let error):
            self.hideIndicator()
            
            var message : String = ""
            if let httpStatusCode = dataResponse.response?.statusCode {
                switch(httpStatusCode) {
                case 400:
                    message = "Username or password not provided."
                    break
                case 401:
                    message = "Incorrect password for user."
                    break
                case 404:
                    message = "URL not found"
                    break
                case 500:
                    message = "Internal Server Error"
                    break
                case 504:
                    message = "The request timed out"
                default :
                    message = error.localizedDescription
                    break
                }
            }else{
                message = error.localizedDescription
            }
            
            Alerter().showAlert(withMessage: message, alertTitle: "Error", alertActions: nil)
        }
        
    }
    
    
    
    
}

extension APICaller {
    
    func getSectionPages(withParameters parameters : [String: Any],withIndicatorMessage msg : String, completion : @escaping ( _ pages : [Any], _ sections : [Any]) -> () ){
        
        showIndicator(withMessage: msg)
        Alamofire.request(Router.getWasteMaterials(parameters)).responseJSON { (dataResponse) in
            self.handleResponse(withResponse: dataResponse, lookFor: ["pages","sections"], completion: { (resultArray) in
                let pages = resultArray.first
                let sections = resultArray.last
                completion(pages as! [Any],sections as! [Any])
            })
        }
    }
    
    func getPageDetail(withParameters parameters : [String: Any],withIndicatorMessage msg : String, completion : @escaping ( _ page : [Any]) -> ()){
        
        showIndicator(withMessage: msg)
        Alamofire.request(Router.getPageById(parameters)).responseJSON { (dataResponse) in
            self.handleResponse(withResponse: dataResponse, lookFor: ["page_detail"], completion: { (resultArray) in
                completion(resultArray.first as! [Any])
            })
        }
    }
    
    
    
    func getWasteMaterials(withParameters parameters : [String: Any],withIndicatorMessage msg : String, completion : @escaping ( _ list : [Any]) -> () ){
        
        showIndicator(withMessage: msg)
        Alamofire.request(Router.getWasteMaterials(parameters)).responseJSON { (dataResponse) in
            self.handleResponse(withResponse: dataResponse, lookFor: ["list"], completion: { (resultArray) in
                completion(resultArray.first as! [Any])
            })
        }
    }
    
    func getProblemTypes(withParameters parameters : [String : Any], withIndicatorMessage msg : String, completion : @escaping ( _ problems : [Any]) -> ()){
        
        showIndicator(withMessage: msg)
        Alamofire.request(Router.getProblemTypes(parameters)).responseJSON { (dataResponse) in
            self.handleResponse(withResponse: dataResponse, lookFor: ["problem_types"], completion: { (resultArray) in
                completion(resultArray.first as! [Any])
            })
        }
    }
    
    
    
    func autoSuggestStreet(withParameters parameters : [String : Any], withIndicatorMessage msg : String, completion : @escaping ( _ streets : [String]) -> ()){
        
        showIndicator(withMessage: msg)
        Alamofire.request(Router.suggestStreet(parameters)).responseJSON { (dataResponse) in
            self.handleResponse(withResponse: dataResponse, lookFor: ["streets"], completion: { (resultArray) in
                completion(resultArray.first as! [String])
            })
        }
    }
    
    func searchLocationwith(Parameters parameters : [String : Any], withIndicatorMessage msg : String, completion : @escaping ( _ results : [Any]) -> ()){
        
        showIndicator(withMessage: msg)
        Alamofire.request(Router.searchLocation(parameters)).responseJSON { (dataResponse) in
            self.handleResponse(withResponse: dataResponse, lookFor: ["results"], completion: { (resultArray) in
                completion(resultArray.first as! [Any])
            })
        }
    }
    
    func getSuburbs(withParameters parameters : [String : Any],withIndicatorMessage msg : String, completion : @escaping ( _ suburbs : [String]) -> () ){
        
        showIndicator(withMessage: msg)
        Alamofire.request(Router.suburbSearch(parameters)).responseJSON { (dataResponse) in
            self.handleResponse(withResponse: dataResponse, lookFor: ["suburbs"], completion: { (resultArray) in
                completion(resultArray.first as! [String])
            })
        }
    }
    

}



