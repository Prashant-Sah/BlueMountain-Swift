//
//  UserInfo.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/24/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation


class UserInfo : NSObject{
    
    var name :          String?
    var email :         String?
    var phone :         String?
    var canBeContacted : Bool?
    
    init(_ name : String?, email : String?, phone: String?, canBeContacted : Bool){
        self.name = name
        self.email = email
        self.phone = phone
        self.canBeContacted = canBeContacted
    }
    
}
