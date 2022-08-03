//
//  UserManager.swift
//  SmartBox
//
//  Created by Agat Levi on 27/04/2022.
//

import Foundation

protocol UserManagerProtocol {
    var userViewModel: UserViewModel? { get }
    func getUserInfo(success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void)
    func logout()
    func userLoggedIn(email: String, password: String, success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void)
    func userSignedUp(email: String, password: String)
}

struct UserInfoResponse: Codable {
    let boxId: String
    let currentWeight: String
    let boxBaseline: String
    let maxWeight: String
    let amazonLink: String?
    
    private enum CodingKeys: String, CodingKey {
        case boxId = "box_id"
        case maxWeight = "max_weight"
        case amazonLink = "amazon_link"
        case currentWeight = "current_weight"
        case boxBaseline = "baseline"
    }
}

class UserManager: UserManagerProtocol {
    var userViewModel: UserViewModel?
    private let sessionManager: SMARTBOXHTTPSessionManager
    
    init(sessionManager: SMARTBOXHTTPSessionManager) {
        self.sessionManager = sessionManager
    }
    
    fileprivate struct UserAPI {
        static let getInfo = "/getinfo"
    }
    
    func logout() {
        userViewModel = nil
    }
    
    func userSignedUp(email: String, password: String) {
        userViewModel = UserViewModel(email: email, password: password)
    }
    
    func userLoggedIn(email: String, password: String, success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void) {
        userViewModel = UserViewModel(email: email, password: password)
        getUserInfo(success: {
            success()
        }, failure: { error, response in
            failure(error, response)
        })
    }
    
    func getUserInfo(success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void) {
        Logger.instance.logEvent(type: .userInfo, info: "getUserInfo")
        guard let userVM = userViewModel else {
            Logger.instance.logEvent(type: .userInfo, info: "getUserInfo failed, view model doesn't exist")
            return
        }
        
        getUserInfoFromServer(username: userVM.email, password: userVM.password, success: { response in
            Logger.instance.logEvent(type: .userInfo, info: "getUserInfo success")
            self.userViewModel = UserViewModel(email: userVM.email, password: userVM.password, boxId: response.boxId, productLink: response.amazonLink, maxWeight: response.maxWeight, currentWeight: response.currentWeight, boxBaseline: response.boxBaseline)
            success()
        }) { error, response in
            Logger.instance.logEvent(type: .userInfo, info: "getUserInfo failed")
            failure(error, response)
        }
    }
    
    private func getUserInfoFromServer(username: String, password: String, success:@escaping (_ response: UserInfoResponse) -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void) {
        Logger.instance.logEvent(type: .userInfo, info: "getUserInfoFromServer")
        if URL(urlString: GlobalManager.instance.baseUrl) == nil {
            Logger.instance.logEvent(type: .userInfo, info: "getUserInfoFromServer failed because of an empty url")
            return
            
        }
        let params: [String:Any] = [ConstantsAPI.tEmail: username, ConstantsAPI.tPassword: password]
        sessionManager.get(baseUrl: GlobalManager.instance.baseUrl, urlPath: UserAPI.getInfo, parameters: params, success: { response in
            if let responseObject = response {
                do {
                    let data = try JSONSerialization.data(withJSONObject: responseObject, options: [])
                    let getInfoResponse = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                    success(getInfoResponse)
                } catch let exception {
                    Logger.instance.logEvent(type: .userInfo, info: "Exception: failed to decode response")
                    failure(nil, response)
                }
            } else {
                Logger.instance.logEvent(type: .userInfo, info: "getUserInfoFromServer failed")
                failure(nil, response)
            }
        }, failure: { error, response in
            Logger.instance.logEvent(type: .userInfo, info: "getUserInfoFromServer failed")
            failure(error, response)
        })
    }
    
}
