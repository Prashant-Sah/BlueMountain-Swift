//
//  FeedbackInfo.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/25/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation

class FeedbackInfo : NSObject{
    
    var problemTypeIndex :  Int?
    var location :          String?
    var message :           String?
    var imageData :         Data?
    
    init(_ problemIndex : Int?, location : String?, message: String?, imageData : Data?){
        self.problemTypeIndex = problemIndex
        self.location = location
        self.message = message
        self.imageData = imageData
    }
    
}
