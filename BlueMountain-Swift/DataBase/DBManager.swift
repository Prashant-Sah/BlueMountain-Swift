//
//  DBManager.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/24/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import FMDB


class DBManager{
    
    let database : FMDatabase?
    //let queue : FMDatabaseQueue?
    static let sharedInstance = DBManager()
    let databaseName : String = "WasteInfo.db"
    
    init() {
        
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databaseName)
        print(fileURL)
        database = FMDatabase(url: fileURL)

        database?.open()
        //queue = FMDatabaseQueue(path: databasePath)
        
        let query1 : String = "create table if not exists pages(page_id integer primary key, page_title text, page_description text, page_content text, page_image text, section_id integer, type_of_calendar integer, latitude text, longitude text, page_status integer, allowed text, not_allowed text, bin_type_id integer, bin_color_id integer, page_order integer)"
        let query2 = "create table if not exists problem_type (id integer primary key autoincrement, title text, email varchar, is_deleted integer)"
        let query3 = "create table if not exists section (id integer primary key, title text, parent_id integer, status integer, type integer)"
       
        do{
            try database?.executeUpdate(query1, values: nil)
            try database?.executeUpdate(query2, values:nil)
            try database?.executeUpdate(query3, values:nil)
        }catch{
            print("Unable to create table")
        }
        
        database?.close()
    }
    
    func pushPagesToDatabase(withArray pages: [Pages] ){
        
        database?.open()
        for page : Pages in pages as [Pages] {
            pushSinglePageToDatabase(withPage: page )
        }
    }
    
    func pushSinglePageToDatabase(withPage page : Pages!){
        
        database?.open()
        do{
            let params : Array = [ page.pageId!, page.pageTitle!, page.pageDescription!, page.pageContent!, page.pageImage!, page.sectionId!, page.typeOfCalendar ?? "",  page.latitude!, page.longitude!, page.pageStatus!, page.allowed ?? false, page.notAllowed ?? false, page.binTypId!, page.binColorId!, page.pageOrder ?? ""  ] as [Any]
            
            try database?.executeUpdate("insert into Posts_table (page_id ,  page_title, page_description , page_content, page_image, section_id , type_of_calendar, latitude, longitude, page_status, allowed, not_allowed, bin_type_id, bin_color_id, page_order ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ", values: params)
        }catch{
            print("Could not insert into database")
        }
        
        //[db executeUpdate:@"insert into Posts_table (page_id ,  page_title, page_description , page_content, page_image, section_id , type_of_calendar, latitude, longitude, page_status, allowed, not_allowed, bin_type_id, bin_color_id, page_order ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ",[NSNumber numberWithInt:  ], [NSNumber numberWithInt:post.postType], [NSString stringWithString: post.title], [NSString stringWithString: post.postSlug], [NSString stringWithString: post.postDescription], [NSNumber numberWithInt:post.numberOfRooms], [NSNumber numberWithInt:post.price], [NSNumber numberWithDouble:post.latitude] , [NSNumber numberWithDouble:post.longitude],[NSString stringWithString: post.location], [NSString stringWithString:post.postCreatedOn], [NSString stringWithString:post.postUpdatedOn], [post.postDeletedOn isEqual:[NSNull null]]?  @"" : [NSString stringWithString:post.postDeletedOn], [NSNumber numberWithInt: post.postUser.userId] ];
    }
    
}

