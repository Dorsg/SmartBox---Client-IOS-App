//
//  loginManager.swift
//  SmartBox
//
//  Created by Agat Levi on 27/04/2022.
//

import Foundation


protocol LoginManagerProtocol {
    func getSignIn(username: String, password: String, success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void)
    func postSignup(username: String, password: String, success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void)
}

class LoginManager: LoginManagerProtocol {
    private let sessionManager: SMARTBOXHTTPSessionManager
    
    fileprivate struct LoginAPI {
        static let signIn = "/signin"
        static let signUp = "/signup"
    }
    
    init(sessionManager: SMARTBOXHTTPSessionManager) {
        self.sessionManager = sessionManager
    }
    
    func getSignIn(username: String, password: String, success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void) {
        if URL(urlString: GlobalManager.instance.baseUrl) == nil { return }
        let params: [String:Any] = [ConstantsAPI.tEmail: username, ConstantsAPI.tPassword: password]
        sessionManager.get(baseUrl: GlobalManager.instance.baseUrl, urlPath: LoginAPI.signIn, parameters: params, success: { response in
            if let responseObject = response {
                do {
                    let data = try  JSONSerialization.data(withJSONObject: responseObject, options: [])
                    if (try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]) != nil {
                    success()
                    } else {
                        failure(nil, response)
                    }
                } catch _ {
                    failure(nil, response)
                }
            } else {
                failure(nil, response)
            }
        }, failure: { error, response in
            failure(error, response)
        })
    }
    
    func postSignup(username: String, password: String, success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void) {
        if URL(urlString: GlobalManager.instance.baseUrl) == nil { return }
        let params: [String:Any] = [ConstantsAPI.tEmail: username, ConstantsAPI.tPassword: password]
        sessionManager.post(baseUrl: GlobalManager.instance.baseUrl, urlPath: LoginAPI.signUp, parameters: params, success: { response in
            if let responseObject = response {
                do {
                    let data = try  JSONSerialization.data(withJSONObject: responseObject, options: [])
                    if (try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]) != nil {
                    success()
                    } else {
                        failure(nil, response)
                    }
                } catch _ {
                    failure(nil, response)
                }
            } else {
                failure(nil, response)
            }
        }, failure: { error, response in
            failure(error, response)
        })
    }
}
