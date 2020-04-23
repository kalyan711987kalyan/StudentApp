//
//  SAPIController.swift
//  Student App
//
//  Created by kalyan on 18/02/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import Foundation
import UIKit
typealias JSONArray = [[String:Any]]

class SAPIController: NSObject {
    static let shared = SAPIController()
    
    func loginAPI(payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
        
        RestService.post(path: .login, payload: payload) { (response, error) in
            guard let response = response as? [String:Any] else {
                completion(nil,error?.localizedDescription)
                return
            }
            
            completion(response, nil)
        }
    }
    
    func registrationAPI(payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
          
          RestService.post(path: .register, payload: payload) { (response, error) in
              guard let response = response as? [String:Any] else {
                  completion(nil,error?.localizedDescription)
                  return
              }
              
              completion(response, nil)
          }
      }
    
    func addKidAPI(payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
        
        RestService.post(path: .addKids, payload: payload) { (response, error) in
            guard let response = response as? [String:Any] else {
                completion(nil,error?.localizedDescription)
                return
            }
            
            completion(response, nil)
        }
    }
    
    
    func getBookSeriesAPI(payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
        
        RestService.get(path: .getbaneers) { (response, error) in
            guard let response = response as? [String:Any] else {
                completion(nil,error?.localizedDescription)
                return
            }
            
            completion(response, nil)
        }
    }
    
    
    func getBannerDetailsAPI(payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
        
        RestService.get(path: .getbaneers) { (response, error) in
            guard let response = response as? [String:Any] else {
                           completion(nil,error?.localizedDescription)
                           return
                       }
                       
                       completion(response, nil)
        }
    }
    
    
    func getSeriesOfBooks(payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
         
         RestService.get(path: .getSeries) { (response, error) in
             guard let response = response as? [String:Any] else {
                            completion(nil,error?.localizedDescription)
                            return
                        }
                        
                        completion(response, nil)
         }
     }
    
    
    func getSupportDetails(payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
        
        RestService.get(path: .getcontactDetails) { (response, error) in
            guard let response = response as? [String:Any] else {
                           completion(nil,error?.localizedDescription)
                           return
                       }
                       
                       completion(response, nil)
        }
    }
    
    func changePasswordAPI(payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
        
        RestService.post(path: .changepassword, payload: payload) { (response, error) in
            guard let response = response as? [String:Any] else {
                completion(nil,error?.localizedDescription)
                return
            }
            
            completion(response, nil)
        }
    }
    
    
//
//    func getlessionsByBook (id : String? ,payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
//       //  ApiUrls(rawValue: "/API/lesson/getLessonDetails/\(id)"+id) ?? ApiUrls(rawValue: "/API/lesson/getLessonDetails/16/2")!
//
//        guard let location = id else {
//
//      print("I hope the weather is nice near you.")
//      return
//      }
//
//        guard let apiUrl = ApiUrls(rawValue: "/API/lesson/getLessonDetails/"+location)! else {
//                  print("I hope the weather is nice near you.")
//            return
//
//        }
//
//
//        RestService.get(path: apiUrl) { (response, error) in
//             guard let response = response as? [String:Any] else {
//                            completion(nil,error?.localizedDescription)
//                            return
//                        }
//
//                        completion(response, nil)
//         }
//     }
    
}
