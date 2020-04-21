//
//  DownloadedVideos+CoreDataProperties.swift
//  
//
//  Created by kalyan on 21/04/20.
//
//

import Foundation
import CoreData


extension DownloadedVideos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadedVideos> {
        return NSFetchRequest<DownloadedVideos>(entityName: "DownloadedVideos")
    }

    @NSManaged public var id: String?
    @NSManaged public var lessonId: String?
    @NSManaged public var videoName: String?
    @NSManaged public var videoSize: String?
    @NSManaged public var videoUrl: String?
    @NSManaged public var videoNameFormated: String?
    @NSManaged public var filePath: String?


}
