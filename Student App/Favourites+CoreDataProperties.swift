//
//  Favourites+CoreDataProperties.swift
//  
//
//  Created by kalyan on 15/04/20.
//
//

import Foundation
import CoreData


extension Favourites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourites> {
        return NSFetchRequest<Favourites>(entityName: "Favourites")
    }

    @NSManaged public var kid_Id: String?
    @NSManaged public var parent_Id: String?
    @NSManaged public var learningbookData: NSObject?
    @NSManaged public var lessionTitle: String?
    @NSManaged public var lstudentsubject: String?
    @NSManaged public var lstudentvideo: NSObject?
    @NSManaged public var lstudentQuestions: NSObject?
    @NSManaged public var lessonId: String?

}
