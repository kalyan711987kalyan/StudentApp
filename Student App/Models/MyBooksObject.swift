//
//  MyBooksObject.swift
//  Student App
//
//  Created by kalyan on 24/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import Foundation

struct MyBooksObject {

    var descrbtion:String!
    
    init(data:[String : Any]) {
        descrbtion = data["customerName"] as? String ?? "No descrption"
    }

}


struct KidObject {

    var studentName: String!
    var className: String!
    var id: String!
    var school: String!
    var parentId: String!
    
    init(data:[String : Any]) {
        studentName = data["studentName"] as? String ?? "No Name"
        className = data["className"] as? String ?? "No Name"
        school = data["school"] as? String ?? "No Name"
        id = data["id"] as? String ?? ""
        parentId = data["parentId"] as? String ?? ""

    }
}

struct ParentObject {

    var parentName: String!
    var email: String!
    var id: String!
    var introductionUrl: String!
    
    
    init(data:[String : Any]) {
        parentName = data["parentName"] as? String ?? "No Name"
        email = data["email"] as? String ?? ""
        introductionUrl = data["introductionUrl"] as? String ?? ""
        id = data["id"] as? String ?? ""
    }
}
struct BooksZone {

    var id: String!
    var logo: String!
    var reason: String!
    var series: String!
    var status: String!
    
    init(data:[String : Any]) {
        id = data["id"] as? String ?? ""
        logo = data["logo"] as? String ?? ""
        reason = data["reason"] as? String ?? ""
        series = data["series"] as? String ?? ""
        status = data["status"] as? String ?? ""

    }
}

struct classBySeriesObjcet {
    var id: String!
    var reason: String!
    var status: String!
    var className: String!
    var deletestatus: String!
    var seriesId: String!

    init(data:[String : Any]) {
        id = data["id"] as? String ?? ""
        reason = data["reason"] as? String ?? ""
        status = data["status"] as? String ?? ""
        className = data["className"] as? String ?? ""
        deletestatus = data["deletestatus"] as? String ?? ""
        seriesId = data["seriesId"] as? String ?? ""
    }
}



struct BookSeriesObject {

    var parentName: String!
    var email: String!
    var id: String!
    var introductionUrl: String!
    
    
    init(data:[String : Any]) {
        parentName = data["parentName"] as? String ?? "No Name"
        email = data["email"] as? String ?? ""
        introductionUrl = data["introductionUrl"] as? String ?? ""
        id = data["id"] as? String ?? ""
    }
}

struct BannerObject {

    var bannerUrl: String!
    var contentUrl: String!
    var bannerId: String!
    var targetUser: String!
    
    
    init(data:[String : Any]) {
        bannerUrl = data["bannerUrl"] as? String ?? ""
        contentUrl = data["contentUrl"] as? String ?? ""
        targetUser = data["targetUser"] as? String ?? ""
        bannerId = data["id"] as? String ?? ""
    }
}

// MARK: - Book
struct downloadBook {
  var bookName : String!
  var bookType : String!
  var description : String!
  var thumbnail : String!
  var bookseries : String!
    
    init(bookName:String, bookType:String, description:String, thumbnail:String, bookseries:String) {
        self.bookName = bookName
        self.bookType = bookType
        self.description = description
        self.thumbnail = thumbnail
        self.bookseries = bookseries

    }
}

struct downloadedBook {
  var bookName : String!
  var bookType : String!
  var description : String!
  var thumbnail : String!
  var bookseries : String!
    var className : String!
    var subjects : NSArray!
    
    init(bookName:String, bookType:String, description:String, thumbnail:String, bookseries:String , className : String , subjects : NSArray) {
        self.bookName = bookName
        self.bookType = bookType
        self.description = description
        self.thumbnail = thumbnail
        self.bookseries = bookseries
        self.className = className
        self.subjects = subjects
    }
}

struct lessonData {
  var lessonName : String!
  var learnings :Int!
  var studentQuestionsAct : Int!
    var studentsubject : NSDictionary
  var studentvideo : NSArray
    var studentQuestions : NSArray

    
    init(lessonName:String, learnings:Int, studentQuestionsAct:Int, studentsubject:NSDictionary , studentvideo: NSArray , studentQuestions : NSArray) {
        self.lessonName = lessonName
        self.learnings = learnings
        self.studentQuestionsAct = studentQuestionsAct
        self.studentsubject = studentsubject
        self.studentvideo = studentvideo
        self.studentQuestions = studentQuestions
    }
}

/*
struct bookObject {

    var bookName: String!
    var bookType: String!
    var description: String!
    
    
    init(data:[String : Any]) {
        bookName = data["bookName"] as? String ?? ""
        bookType = data["bookType"] as? String ?? ""
        description = data["description"] as? String ?? ""
    }
}
*/
/*
struct Book: Codable {
    let reason, status, bookID, bookName: String
    let booktypeID, classID: String
    let createdDate: Date
    let bookDescription, seriesID: String
    let studentbooktype: Studentbooktype
    let studentclass: Studentclass
    let studentseries: Studentseries
    let subjects: Subjects
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case reason, status
        case bookID = "bookId"
        case bookName
        case booktypeID = "booktypeId"
        case classID = "classId"
        case createdDate
        case bookDescription = "description"
        case seriesID = "seriesId"
        case studentbooktype, studentclass, studentseries, subjects, thumbnail
    }
}

// MARK: - Studentbooktype
struct Studentbooktype: Codable {
    let bookType, id: String
}

// MARK: - Studentclass
struct Studentclass: Codable {
    let reason, status, className, deletestatus: String
    let id, seriesID: String

    enum CodingKeys: String, CodingKey {
        case reason, status, className, deletestatus, id
        case seriesID = "seriesId"
    }
}

// MARK: - Studentseries
struct Studentseries: Codable {
    let reason, status, id: String
    let logo: String
    let series: String
}

// MARK: - Subjects
struct Subjects: Codable {
    let bookID: String
    let createdDate: Date
    let id: String
    let studentsubject: Studentsubject
    let subjectID: String

    enum CodingKeys: String, CodingKey {
        case bookID = "bookId"
        case createdDate, id, studentsubject
        case subjectID = "subjectId"
    }
}

// MARK: - Studentsubject
struct Studentsubject: Codable {
    let reason, status, id, subjectName: String
}
 */
