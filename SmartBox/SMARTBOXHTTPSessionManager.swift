//
//  SMARTBOXHTTPSessionManager.swift
//  SmartBox
//
//  Created by Agat Levi on 27/04/2022.
//

import Foundation
import Alamofire

class SMARTBOXHTTPSessionManager {
    var alamofireManager: Session
    
    init() {
        alamofireManager = IBGSessionManager.sharedManager
    }
    
    func get(baseUrl: String, urlPath: String, parameters: [String:Any], success:@escaping (_ response:AnyObject?) -> Void, failure:@escaping (_ error:Error?, _ response:AnyObject?) -> Void) {
        guard let baseUrlObject = URL(urlString: baseUrl) else {
            failure(nil,nil)
            return
        }
        
        let url: URL
        if !urlPath.isEmpty {
            url = baseUrlObject.appendingPathComponent(urlPath)
        } else {
            url = baseUrlObject
        }
        
        alamofireManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON {
            [weak self] response in
            self?.handleResponse(url: url.absoluteString, baseUrl: baseUrl, urlString: urlPath, response: response, success: success, failure: failure)
        }
    }
    
    func post(baseUrl: String, urlPath: String, parameters: [String:Any],
              success:@escaping (_ response:AnyObject?)->() , failure:@escaping (_ error:Error?, _ response:AnyObject?)->()) {
        
        guard let baseUrlObject = URL(urlString: baseUrl) else {
            failure(nil, nil)
            return
        }
        
        let url = baseUrlObject.appendingPathComponent(urlPath)
        
        alamofireManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { [weak self] response in
            self?.handleResponse(url: url.absoluteString, baseUrl: baseUrl, urlString: urlPath, response: response, success: success, failure: failure)
        }
    }
    
    private func handleResponse(url: String, baseUrl: String, urlString: String, response:  AFDataResponse<Any>, success: @escaping (_ response:AnyObject?)->() , failure: @escaping (_ error:Error?, _ response:AnyObject?)->()) {
            
        if let _ = response.error as NSError? {

            failure(response.error, response.value as AnyObject?)
        } else if 200 <= response.response!.statusCode && response.response!.statusCode < 300 {
            success(response.value as AnyObject?)
        } else {
            enum responseError: Error {
                case statusCodeInvalid(Int)
            }
            let err = responseError.statusCodeInvalid(response.response!.statusCode as Int)
            failure(err, response.value as AnyObject?)
        }
    }

}

class IBGSessionManager: Alamofire.Session {
    static let sharedManager: IBGSessionManager = {
        let configuration = URLSessionConfiguration.default
        let manager = IBGSessionManager(configuration: configuration)
        return manager
    }()
}
