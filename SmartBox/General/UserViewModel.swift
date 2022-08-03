//
//  UserViewModel.swift
//  SmartBox
//
//  Created by Agat Levi on 27/04/2022.
//

import Foundation

struct UserViewModel {
    let email: String
    let password: String
    let boxId: String?
    let productLink: String?
    let maxWeight: String?
    let currentWeight: String?
    let boxBaseline: String?
    
    init(email: String, password: String, boxId: String? = nil, productLink: String? = nil, maxWeight: String? = nil, currentWeight: String? = nil, boxBaseline: String? =  nil) {
        self.email = email
        self.password = password
        self.boxId = boxId
        self.productLink = productLink
        self.currentWeight = currentWeight
        self.boxBaseline = boxBaseline
        self.maxWeight = maxWeight
        Logger.instance.logEvent(type: .login, info: "userViewModel initialized. \nemail: \(self.email) \nbox ID: \(String(describing: self.boxId))\nbox state: \(self.currentWeight)\nbox threshold: \(self.boxBaseline)  ")
    }
}
