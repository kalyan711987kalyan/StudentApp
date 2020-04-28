//
//  DownloadedBooks+CoreDataProperties.swift
//  Student App
//
//  Created by kalyan on 07/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//
//

import Foundation
import CoreData


extension DownloadedBooks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadedBooks> {
        return NSFetchRequest<DownloadedBooks>(entityName: "DownloadedBooks")
    }

    @NSManaged public var kid_Id: String?
    @NSManaged public var parent_Id: String?
    @NSManaged public var bookData: String?
    @NSManaged public var book_id: String?
    @NSManaged public var bookTypeId: String?

}
