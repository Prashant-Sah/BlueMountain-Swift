//
//  Sections.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 9/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import ObjectMapper

class Sections : Mappable{
    
    var sectionId : String?
    var title : String?
    var parentId : String?
    var status : String?
    
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        sectionId   <- map["section_id"]
        title       <- map["title"]
        parentId    <- map["parent_id"]
        status      <- map["status"]
    }
}
