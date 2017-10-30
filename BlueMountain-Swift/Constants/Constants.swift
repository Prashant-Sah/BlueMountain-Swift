//
//  Constants.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/20/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation

let BASE_URL = "http://ci.draftserver.com/bluemountainapp/webservice"

let WASTE_MATERAILS_PATH = "/pages/get_waste_materials"
let GET_PAGES_BY_SECTION_ID_PATH = "/section/get_section_pages_by_section_id"
let GET_PAGES_DETAILS_PATH = "/pages/get_detail"
let GET_PROBLEM_TYPES_PATH = "/get_problem_types"
let FEEDBACK_PATH = "/feedback"
let SUBURB_SEARCH_PATH = "/location/suburb_search"
let SEARCH_LOCATION_PATH = "/location/search"
let STREET_NAME_SUGGEST_PATH = "/location/auto_suggest"

let SUCCESS = "0001"

let locationSelectedNotificationKey = NSNotification.Name.init(rawValue: "com.blueMountain.locationNotificationKey")
