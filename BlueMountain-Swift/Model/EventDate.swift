//
//  EventDate.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 11/9/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import ObjectMapper

class EventDate {
    
    var garbageDates = [Date]()
    var organicDates = [Date]()
    var recyclingDates = [Date]()
    
    
    func getCollectionDates() -> [[Date]]{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let data = UserDefaults.standard.value(forKey: "Location")
        let locationInfo = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! StreetGarbageInfo
        
        let binColors = locationInfo.binColors?.components(separatedBy: ",")
        let intervals = locationInfo.collectionFrequencies?.components(separatedBy: ",")
        if let binCount = binColors?.count{
            for i in 0..<binCount {
                if let interval = Int((intervals?[i])!), let color = Int((binColors?[i])!) {
                    switch color {
                    case 1:
                        let garbageDates = generateEventDates(from: dateFormatter.date(from: locationInfo.garbageCollectionDate!)!, with: interval)
                    case 2:
                        let organicDates = generateEventDates(from: dateFormatter.date(from: locationInfo.organicsCollectionDate!)!, with: interval)
                    case 3:
                        let recyclingDates = generateEventDates(from: dateFormatter.date(from: locationInfo.recyclingCollectionDate!)!, with: interval)
                    default:
                        break
                    }
                    
                }
                
            }
        }
        return [garbageDates, organicDates, recyclingDates]
    }
    
    func generateEventDates(from date:Date, with interval:Int) -> [Date] {
        
        let cal = Calendar.current
        let d = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        let c = cal.dateComponents([.year,.month], from: d!)
        let startDate = cal.date(from: c)
        return [startDate!]
    }
    
}
