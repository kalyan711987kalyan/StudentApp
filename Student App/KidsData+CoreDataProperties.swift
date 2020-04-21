//
//  KidsData+CoreDataProperties.swift
//  Student App
//
//  Created by kalyan on 07/03/20.
//  Copyright © 2020 kalyan. All rights reserved.
//
//

import Foundation
import CoreData


extension KidsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KidsData> {
        return NSFetchRequest<KidsData>(entityName: "KidsData")
    }

    @NSManaged public var kidName: String?
    @NSManaged public var kidSchool: String?
    @NSManaged public var kidClass: String?
    @NSManaged public var kid_Id: String?
    @NSManaged public var parent_Id: String?


}
