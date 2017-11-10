//
//  StreetGarbageInfo.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import ObjectMapper

class StreetGarbageInfo : NSObject, NSCoding,  Mappable {
    

 
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
    var organicsCollectionDate : String?
    var recyclingCollectionDate: String?
    
    required init(coder aDecoder: NSCoder) {
        self.unitNumber = aDecoder.decodeObject(forKey: "unitNumber") as? String
        self.houseNumber = aDecoder.decodeObject(forKey: "houseNumber") as? String
        self.street = aDecoder.decodeObject(forKey: "street") as? String
        self.suburb = aDecoder.decodeObject(forKey: "suburb") as? String
        self.postCode = aDecoder.decodeObject(forKey: "postCode") as? String
        self.collectionDay = aDecoder.decodeObject(forKey: "collectionDay") as? String
        self.collectionWeek = aDecoder.decodeObject(forKey: "collectionWeek") as? String
        self.binType = aDecoder.decodeObject(forKey: "binType") as? String
        self.dateTime = aDecoder.decodeObject(forKey: "dateTime") as? String
        self.currentWeekType = aDecoder.decodeObject(forKey: "currentWeekType") as? String
        self.binColors = aDecoder.decodeObject(forKey: "binColors") as? String
        self.collectionFrequencies = aDecoder.decodeObject(forKey: "collectionFrequencies") as? String
        self.area = aDecoder.decodeObject(forKey: "area") as? String
        self.garbageCollectionDate = aDecoder.decodeObject(forKey: "garbageCollectionDate") as? String
        self.organicsCollectionDate = aDecoder.decodeObject(forKey: "organicsCollectionDate") as? String
        self.recyclingCollectionDate = aDecoder.decodeObject(forKey: "recyclingCollectionDate") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(unitNumber, forKey: "unitNumber")
        aCoder.encode(houseNumber, forKey: "houseNumber")
        aCoder.encode(street, forKey: "street")
        aCoder.encode(suburb, forKey: "suburb")
        aCoder.encode(postCode, forKey: "postCode")
        aCoder.encode(collectionDay, forKey: "collectionDay")
        aCoder.encode(collectionWeek, forKey: "collectionWeek")
        aCoder.encode(binType, forKey: "binType")
        aCoder.encode(dateTime, forKey: "dateTime")
        aCoder.encode(currentWeekType, forKey: "currentWeekType")
        aCoder.encode(binColors, forKey: "binColors")
        aCoder.encode(houseNumber, forKey: "houseNumber")
        aCoder.encode(collectionFrequencies, forKey: "collectionFrequencies")
        aCoder.encode(area, forKey: "area")
        aCoder.encode(garbageCollectionDate, forKey: "garbageCollectionDate")
        aCoder.encode(organicsCollectionDate, forKey: "organicsCollectionDate")
        aCoder.encode(recyclingCollectionDate, forKey: "recyclingCollectionDate")

    }
    
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
        organicsCollectionDate  <- map["item_organics"]
        recyclingCollectionDate <- map["item_recycling"]
    }
    
}
