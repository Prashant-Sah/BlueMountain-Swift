//
//  ProblemTypes.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/23/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import ObjectMapper

class ProblemTypes : Mappable{

    var problemTypeId : String?
    var title : String?
    var isDeleted : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        problemTypeId   <- map["id"]
        title           <- map["title"]
        isDeleted       <- map["is_deleted"]
    }
}


