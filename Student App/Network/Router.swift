//
//  Router.swift
//  AccuShield
//
//  Created by Narendra Kumar R on 11/15/18.
//  Copyright © 2018 AccuShield. All rights reserved.
//

import Foundation
import Alamofire

enum ApiUrls: String {
    
    func someTest(id : String) -> String{
        
        return "\(self)\(id)"
    }
    
    case login = "/API/LoginAPI/parentLogin"
    case getSeries = "/API/series/getSeriesDetails/smartkids"
    case getbookdetails = "/API/book/getBookDetails"
    case getbaneers = "/API/banner/getBanners"
    case getcontactDetails = "/API/contactus/details"
    case verifyOTP = "/API/LoginAPI/verifyOTP"
    case register = "/API/studentReg/register"
    case addKids = "/API/studentReg/addkids"
    case changepassword = "/API/LoginAPI/changePasswordSmartKids"
}



enum APIEndPoints{
    case base
    var urlString: String{
        switch self {
        case .base:
            return "http://13.233.95.84:8080/SmartKids"
        
        }
    }
}

struct RestOptions {
    var headers: [String:String]?
    var apiEndpoint:APIEndPoints?
}

enum Router: URLRequestConvertible {
    case get (path : ApiUrls, parameters : Parameters, options: RestOptions?)
    case post (path: ApiUrls, query_parameters: Parameters, payload : Parameters, options: RestOptions?)
    case put(path: ApiUrls, query_parameters: Parameters, payload : Parameters, options: RestOptions?)
    case patch(path: ApiUrls, query_parameters: Parameters, payload : Parameters, options: RestOptions?)
    case delete(path: ApiUrls, query_parameters: Parameters, payload : Parameters, options: RestOptions?)
    
    static let baseURLString = APIEndPoints.base.urlString
        
    var method: HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .patch:
            return .patch
        case .delete:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .get(let path, let params,_):
            return Router.formatUrl(url: path.rawValue, params: params)
        case .post(let path, _, let params,_), .put(let path, _, let params,_), .patch(let path, _, let params,_), .delete(let path, _, let params,_):
            return Router.formatUrl(url: path.rawValue, params: params)
        }
    }
    
    static func formatUrl(url: String, params: Parameters) -> String {
        var replaceUrl = url
        for (key, value) in params {
            let parameterString = ":\(key)"
            if url.range(of: parameterString) != nil {
                replaceUrl = replaceUrl.replacingOccurrences(of: parameterString, with: value as! String)
            }
        }
        return replaceUrl
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest: URLRequest!
        switch self {
        case .get(_, let parameters, let options):
            urlRequest = try prepareRequest(parameters: parameters, options: options)
        case .post(_, let query_params, let parameters, let options):
            urlRequest = try prepareRequest(parameters: query_params, options: options)
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .put(_, let query_params, let parameters, let options), .patch(_, let query_params, let parameters, let options),.delete(_, let query_params, let parameters, let options):
            urlRequest = try prepareRequest(parameters: query_params, options: options)
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        print("request made: \(urlRequest)")
        return urlRequest
    }
    
    private func prepareRequest(parameters: Parameters, options: RestOptions?) throws -> URLRequest{
        var url: URL!
        
        if let endpoint = options?.apiEndpoint {
            url = try endpoint.urlString.asURL()
        } else {
            url = try Router.baseURLString.asURL()
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("ios", forHTTPHeaderField: "User-Agent")
        
        
        if let headers = options?.headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
//        if let fireToken = KeychainService.fireToken() {
//            urlRequest.addValue(fireToken, forHTTPHeaderField: "Firebase-Token")
//        }
        
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
        return urlRequest
    }
}
