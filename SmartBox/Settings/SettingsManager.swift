//
//  SettingsManager.swift
//  SmartBox
//
//  Created by Agat Levi on 25/05/2022.
//

import Foundation

protocol SettingsManagerProtocol {
    func updateSettingsInDB(boxId: String, currentWeight: String, threshold: String, productLink: String, success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void)
}

class SettingsManager: SettingsManagerProtocol {
    private let sessionManager: SMARTBOXHTTPSessionManager

    fileprivate struct SettingsAPI {
        static let settingsUpdate = "/settingupdate"
    }
    
    init(sessionManager: SMARTBOXHTTPSessionManager) {
        self.sessionManager = sessionManager
    }
    
    func updateSettingsInDB(boxId: String, currentWeight: String, threshold: String, productLink: String, success:@escaping () -> Void, failure:@escaping (_ error:Error?, _ response: AnyObject?) -> Void){
        
        if URL(urlString: GlobalManager.instance.baseUrl) == nil { return }
        guard let email = GlobalManager.instance.userManager.userViewModel?.email else { return }
        
        let params: [String:Any] = [ConstantsAPI.tEmail: email, ConstantsAPI.tBoxThreshold: threshold, ConstantsAPI.tCurrentWeight: currentWeight, ConstantsAPI.tAmazonLink: productLink,
            ConstantsAPI.tBoxId: boxId
        ]
        
        sessionManager.post(baseUrl: GlobalManager.instance.baseUrl, urlPath: SettingsAPI.settingsUpdate, parameters: params, success: { response in
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
