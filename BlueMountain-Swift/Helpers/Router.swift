//
//  Router.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 11/6/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

enum Router: URLRequestConvertible {
    
    static let baseUrl = "http://ci.draftserver.com/bluemountainapp/webservice"
    
    case fetchSyncData([String:Any])
    case feedBack([String:Any])
    case getProblemTypes([String:Any])
    case searchLocation([String:Any])
    case suburbSearch([String:Any])
    case suggestStreet([String:Any])
    case getSectionPages([String:Any])
    case getPageById([String:Any])
    case getPagesWithMultipleIds([String:Any])
    case getWasteMaterials([String:Any])
    case getCalendars([String:Any])
    case getLocationUpdate([String:Any])
    case registerDevice([String:Any])
    case updateDeviceLocation([String:Any])
    case getFeedbackContent
    
    var method: HTTPMethod {
        
        switch self {
        case .fetchSyncData,.feedBack,.getProblemTypes,.searchLocation,.suburbSearch,.suggestStreet,.getSectionPages,.getPageById,.getPagesWithMultipleIds,.getWasteMaterials,.getCalendars,.getFeedbackContent,.getLocationUpdate,.registerDevice,.updateDeviceLocation: return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchSyncData:            return "get_updated_data"
        case .feedBack:                 return "feedback"
        case .getProblemTypes:          return "get_problem_types"
        case .searchLocation:           return "location/search"
        case .suburbSearch:             return "location/suburb_search"
        case .suggestStreet:            return "location/auto_suggest"
        case .getSectionPages:          return "section/get_section_pages_by_section_id"
        case .getPageById:              return "pages/get_detail"
        case .getPagesWithMultipleIds:  return "pages/get_detail_array"
        case .getWasteMaterials:        return "pages/get_waste_materials"
        case .getCalendars:             return "pages/get_calendars"
        case .getFeedbackContent:       return "get_feedback_content"
        case .getLocationUpdate:        return "location/check_update"
        case .registerDevice:           return "register_device"
        case .updateDeviceLocation:     return "update_device_location"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Router.baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 10
        
        switch  self {
        case .fetchSyncData (let parameters),
             .feedBack (let parameters),
             .getProblemTypes (let parameters),
             .searchLocation (let parameters),
             .suburbSearch (let parameters),
             .suggestStreet (let parameters),
             .getSectionPages (let parameters),
             .getPageById (let parameters),
             .getPagesWithMultipleIds (let parameters),
             .getWasteMaterials (let parameters),
             .getCalendars (let parameters),
             .getLocationUpdate (let parameters),
             .registerDevice (let parameters),
             .updateDeviceLocation (let parameters):
            
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        default: break
        }
        return urlRequest
    }
}
