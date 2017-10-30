//
//  StreetGarbageInfo.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import ObjectMapper

class StreetGarbageInfo : Mappable {
 
    var unitNumber : String?
    var houseNumber : String?
    var street : String?
    var suburb : String?
    var postCode : String?
    var collectionDay : String?
    var collectionWeek : String?
    var binType : String?
    var dateTime : String?
    var currentWeekType : String?
    var binColors : String?
    var collectionFrequencies : String?
    var area : String?
    var garbageCollectionDate : String?
    var OrganicsCollectionDate : String?
    var RecyclingCollectionDate: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        unitNumber              <- map["unit_number"]
        houseNumber             <- map["house_number"]
        street                  <- map["street"]
        suburb                  <- map["suburb"]
        postCode                <- map["postcode"]
        collectionDay           <- map["collection_day"]
        collectionWeek          <- map["collection_week"]
        binType                 <- map["bin_type"]
        dateTime                <- map["date_time"]
        currentWeekType         <- map["current_week_type"]
        binColors               <- map["bin_colors"]
        collectionFrequencies   <- map["collection_frequencies"]
        area                    <- map["area"]
        garbageCollectionDate   <- map["item_garbage"]
        OrganicsCollectionDate  <- map["item_organics"]
        RecyclingCollectionDate <- map["item_recycling"]
    }
    
}
