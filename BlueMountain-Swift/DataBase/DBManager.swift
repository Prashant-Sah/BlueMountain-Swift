//
//  DBManager.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/24/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import FMDB
import ObjectMapper


class DBManager{
    
    var database : FMDatabase = FMDatabase()
    //let queue : FMDatabaseQueue?
    static let sharedInstance = DBManager()
    let databaseName : String = "WasteInfo.db"
    
    init() {
        
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databaseName)
        print(fileURL)
        self.database = FMDatabase(url: fileURL)
        
        database.open()
        //queue = FMDatabaseQueue(path: databasePath)
        
        let query1 : String = "create table if not exists pages(page_id integer primary key, page_title text, page_description text, page_content text, page_image text, section_id integer, type_of_calendar integer, latitude text, longitude text, page_status integer, allowed text, not_allowed text, bin_type_id integer, bin_color_id text, page_order integer)"
        
        let query2 = "create table if not exists problem_types (id integer primary key autoincrement, title text, email varchar, is_deleted integer)"
        
        let query3 = "create table if not exists sections (section_id integer primary key, title text, parent_id integer, status integer)"
        
        do{
            try database.executeUpdate(query1, values: nil)
            try database.executeUpdate(query2, values:nil)
            try database.executeUpdate(query3, values:nil)
        }catch{
            print("Unable to create table")
        }
        
        database.close()
    }
    
    func pushPagesToDatabase(withArray pages: [Pages] ){
        
        for page : Pages in pages as [Pages] {
            pushSinglePageToDatabase(withPage: page )
        }
    }
    
    func pushSinglePageToDatabase(withPage page : Pages!){
        
        database.open()
        do{
            let params : Array = [ page.pageId!  , page.pageTitle!, page.pageDescription!, page.pageContent ?? "", page.pageImage!, page.sectionId!, page.typeOfCalendar ?? "",  page.latitude!, page.longitude!, page.pageStatus!, page.allowed ?? false, page.notAllowed ?? false, page.binTypeId ?? "", page.binColorId ?? "", page.pageOrder ?? ""  ] as [Any]
            
            try database.executeUpdate("insert into pages (page_id ,  page_title, page_description , page_content, page_image, section_id , type_of_calendar, latitude, longitude, page_status, allowed, not_allowed, bin_type_id, bin_color_id, page_order ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ", values: params)
        }catch{
            print("Could not insert into database")
        }
    }
    
    
    func getPagesFromDatabase(withQuery query : String) -> [Pages]? {
        
        var pages : [Pages] = [Pages]()
        database.open()
        do{
            let results = try database.executeQuery(query, values: nil)
            while results.next() {
                let page = Mapper<Pages>().map(JSONObject: results.resultDictionary)
                pages.append(page!)
            }
            
        } catch{
            print("Error retrieving pages from database")
        }
        database.close()
        return pages
    }
    
}

// MARK:  Section related events
extension DBManager {
    
    func pushSectionsToDatabase(withSections sections : [Sections]){
        
        for section in sections{
            pushSingleSectionToDatabase(withSection: section)
        }
    }
    
    
    func pushSingleSectionToDatabase(withSection section : Sections){
        
        database.open()
        do{
            let params : Array = [ section.sectionId!  , section.title!, section.parentId!, section.status!] as [Any]
            
            try database.executeUpdate("insert into sections (section_id ,  title, parent_id , status ) values (?,?,?,?) ", values: params)
        }catch{
            print("Could not insert into database")
        }
        database.close()
    }
    
    func getSectionsFromDatabase(withQuery query : String) -> [Sections] {
        
        var sections : [Sections] = [Sections]()
        database.open()
        do{
            let results = try database.executeQuery(query, values: nil)
            while results.next() {
                let section = Mapper<Sections>().map(JSONObject: results.resultDictionary)
                sections.append(section!)
            }
        } catch{
            print("Error retrieving section from database")
        }
        database.close()
        return sections
    }
}

