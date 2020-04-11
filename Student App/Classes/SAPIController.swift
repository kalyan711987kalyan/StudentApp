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
    
    func getClassBySeries(payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
         
         RestService.get(path: .getclassdetails) { (response, error) in
             guard let response = response as? [String:Any] else {
                            completion(nil,error?.localizedDescription)
                            return
                        }
                        
                        completion(response, nil)
         }
     }
    
    
    func getallBooksByClass(id : String ,payload: [String: Any], completion: @escaping (_ result: Any?, _ errorMessage: String?) -> Void) {
         
        RestService.get(path: .getbookdetails ) { (response, error) in
             guard let response = response as? [String:Any] else {
                            completion(nil,error?.localizedDescription)
                            return
                        }
                        
                        completion(response, nil)
         }
     }
    
}