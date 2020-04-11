//
//  RestService.swift
//  AccuShield
//
//  Created by Narendra Kumar R on 11/15/18.
//  Copyright © 2018 AccuShield. All rights reserved.
//

import Foundation
import Alamofire

struct RestDocument{
    var key: String
    var fileName: String
    var data: Data
    var mimeType: String
}

class RestService {
    static func convertToDictionary(data: Data?) -> [String: Any]? {
        if  data != nil {
            do {
                return try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func handleError(response: DataResponse<Any>) {
        if let httpUrlResponse = response.response {
            switch httpUrlResponse.statusCode {
            case 401:
                
                break
            default:
                print(response.request?.url?.absoluteURL ?? "")
                print(response.result.value ?? "no error message in response")
            }
        }
    }
    
    static func handleError(response: DataResponse<Data>) {
        if let httpUrlResponse = response.response {
            switch httpUrlResponse.statusCode {
            case 401:
                
                break
            default:
                print(response.request?.url?.absoluteURL ?? "")
                print(response.result.value ?? "no error message in response")
                
            }
        }
        
    }
    
    
    static func makeCall(urlRequest: Router, completionHandler: @escaping (Any?, Error? ) -> Void) -> DataRequest {
        
       return Alamofire.request(urlRequest).validate().responseJSON { (response) in
            switch response.result {
            case .success(let data):
                completionHandler(data, nil)
            case .failure(let error):
                print(error.localizedDescription)
                handleError(response: response)
                let errorData = convertToDictionary(data: response.data)
                completionHandler(errorData, error)
            }
        }
    }
    
    private static func makeCallForData(urlRequest: Router, completionHandler: @escaping (Data?, Error? ) -> Void) -> DataRequest {
        return Alamofire.request(urlRequest).validate().responseData { (response) in
            switch response.result {
            case .success:
                completionHandler(response.result.value, nil)
            case .failure(let error):
                print(error.localizedDescription)
                handleError(response: response)
                completionHandler(response.data, error)
            }
        }
    }
    
    private static func makeCallForDataDownload(urlRequest: Router, completionHandler: @escaping (Data?, Error? ) -> Void) -> DataRequest {
        return Alamofire.request(urlRequest).responseData { (response) in
            switch response.result {
            case .success:
                completionHandler(response.result.value, nil)
            case .failure(let error):
                print(error.localizedDescription)
                handleError(response: response)
                completionHandler(response.data, error)
            }
        }
    }
    
    private static func makeFormUploadCall(path: ApiUrls, method: HTTPMethod, query_params: [String:String]? = [:], payload: Parameters? = [:],files:[RestDocument]?, options: RestOptions? = nil, completionHandler : @escaping (Any?, Error? ) -> Void){
        var completeURL: String!
        if let endpoint = options?.apiEndpoint {
            completeURL = endpoint.urlString
        } else {
            completeURL = Router.baseURLString
        }
        if let params = payload {
            completeURL = completeURL + "/" + Router.formatUrl(url: path.rawValue, params: params)
        }
        
        if let params = query_params, params.count > 0, let url = URL(string: completeURL) {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            var queryItems: [URLQueryItem] = []
            for (key, value) in params {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            urlComponents?.queryItems = queryItems
            completeURL = (urlComponents?.url)?.absoluteString ?? ""
        }
        
        var headers: HTTPHeaders = ["Content-type": "multipart/form-data","User-Agent":"ios"]
//        if let sessionRandomIdentifier = IdyllicUser.shared.sessionRandomIdentifier {
//            headers[Router.accessTokenHeader] = sessionRandomIdentifier
//        }
        if let httpHeaders = options?.headers {
            for (key, value) in httpHeaders {
                headers[key] = value
            }
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let payload = payload {
                for (key, value) in payload {
                    var fieldContents: String!
                    if let dictPayload = value as? NSDictionary {
                        fieldContents = try? String(data: JSONSerialization.data(withJSONObject: dictPayload, options: .prettyPrinted), encoding: String.Encoding.utf8) ?? ""
                    } else {
                        fieldContents = "\(value)"
                    }
                    
                    multipartFormData.append(fieldContents.data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            if let files = files{
                for file in files {
                    multipartFormData.append(file.data, withName: file.key, fileName: file.fileName, mimeType: file.mimeType)
                }
            }
        }, usingThreshold: UInt64.init(), to: completeURL, method: method, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        completionHandler(response.result.value, nil)
                    case .failure(let error):
                        print(error.localizedDescription)
                        handleError(response: response)
                        let errorData = convertToDictionary(data: response.data)
                        completionHandler(errorData?["message"] as? Data, error)
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionHandler("Error on preparing payload", error)
            }
        }
    }
    
    
    static func get(path: ApiUrls, parameters: Parameters? = [:], options: RestOptions? = nil, completionHandler : @escaping (Any?, Error? ) -> Void) -> DataRequest  {
        
        let request = Router.get(path: path, parameters: parameters!,options: options)
        return makeCall(urlRequest: request, completionHandler: completionHandler)
    }
    
    static func getData(path: ApiUrls, parameters: Parameters? = [:], options: RestOptions? = nil, completionHandler : @escaping (Data?, Error? ) -> Void) -> DataRequest {
        let request = Router.get(path: path, parameters: parameters!,options: options)
        return makeCallForData(urlRequest: request, completionHandler: completionHandler)
    }
    
    
    static func post(path: ApiUrls, query_params: Parameters? = [:], payload: Parameters?,options: RestOptions? = nil, completionHandler : @escaping (Any?, Error?) -> Void) -> DataRequest {
        let request = Router.post(path: path, query_parameters: query_params!, payload: payload!,options: options)
        return makeCall(urlRequest: request, completionHandler: completionHandler)
    }
    
    static func put(path: ApiUrls, query_params: Parameters? = [:], payload: Parameters? = [:], options: RestOptions? = nil, completionHandler : @escaping (Any?, Error?) -> Void) -> DataRequest {
        
        let request = Router.put(path: path, query_parameters: query_params!, payload: payload!,options: options)
        return makeCall(urlRequest: request, completionHandler: completionHandler)
    }
    
    
    static func patch(path: ApiUrls, query_params: Parameters? = [:], payload: Parameters? = [:], options: RestOptions? = nil, completionHandler : @escaping (Any?, Error?) -> Void) -> DataRequest {
        
        let request = Router.patch(path: path, query_parameters: query_params!, payload: payload!,options: options)
        return makeCall(urlRequest: request, completionHandler: completionHandler)
    }
    
    
    static func delete(path: ApiUrls, query_params: Parameters? = [:], payload: Parameters? = [:],options: RestOptions? = nil, completionHandler : @escaping (Any?, Error?) -> Void) -> DataRequest {
        let request = Router.delete(path: path, query_parameters: query_params!, payload: payload!,options: options)
        return makeCall(urlRequest: request, completionHandler: completionHandler)
    }
    
    static func upload(path: ApiUrls, query_params: Parameters? = [:], payload: Parameters? = [:], files:[RestDocument]?, method: HTTPMethod,options: RestOptions? = nil, completionHandler : @escaping (Any?, Error?) -> Void)  {
         makeFormUploadCall(path: path, method: method, query_params: query_params as? Dictionary, payload: payload, files: files, options: options, completionHandler: completionHandler)
    }
    
    static func downloadGet(path: ApiUrls, parameters: Parameters? = [:], options: RestOptions? = nil, completionHandler : @escaping (Data?, Error? ) -> Void) -> DataRequest {
        let request = Router.get(path: path, parameters: parameters!,options: options)
        return makeCallForDataDownload(urlRequest: request, completionHandler: completionHandler)
    }
    
}
