//
//  Pages.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/20/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import ObjectMapper

class Pages : Mappable{
    
    var  pageId : Int?
    var  pageTitle : String?
    var  pageDescription : String?
    var  pageContent : String?
    var  pageImage : String?
    var  sectionId : Int?
    var  typeOfCalendar : Int?
    var  latitude : String?
    var  longitude : String?
    var  pageStatus : Int?
    var  allowed : String?
    var  notAllowed : String?
    var  binTypId : Int?
    var  binColorId : Int?
    var  pageOrder : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        pageId    <- map["page_id"]
        pageTitle         <- map["page_title"]
        pageDescription      <- map["page_description"]
        pageContent       <- map["page_content"]
        pageImage  <- map["page_image"]
        sectionId  <- map["section_id"]
        typeOfCalendar     <- map["typeOfCalendar"] //N/A
        latitude    <- map["latitude"]
        longitude    <- map["longitude"]
        pageStatus         <- map["page_status"]
        allowed      <- map["allowed"]              //N/A
        notAllowed       <- map["not_allowed"]       //N/A
        binTypId  <- map["bin_type_id"]
        binColorId  <- map["bin_color_id"]
        pageOrder  <- map["page_order"]
           }
    
    init(fromJson PagesDictionary: NSDictionary){
        
        self.pageId = PagesDictionary["page_id"] as? Int
        self.pageTitle = PagesDictionary["page_title"] as? String
        self.pageDescription = PagesDictionary["page_description"] as? String
        self.pageContent = PagesDictionary["page_content"] as? String
        self.pageImage = PagesDictionary["page_image"] as? String
        self.sectionId = PagesDictionary["section_id"] as? Int
        self.typeOfCalendar = PagesDictionary["type_of_calender"] as? Int
        self.latitude = PagesDictionary["latitude"] as? String
        self.longitude = PagesDictionary["longitude"] as? String
        self.pageStatus = PagesDictionary["page_status"] as? Int
        self.allowed = PagesDictionary["allowed"] as? String
        self.notAllowed = PagesDictionary["not_allowed"] as? String
        self.binTypId = PagesDictionary["bin_type_id"] as? Int
        self.binColorId = PagesDictionary["bin_color_id"] as? Int
        
    }
    
}
