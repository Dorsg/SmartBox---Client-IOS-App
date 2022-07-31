//
//  Logger.swift
//  SmartBox
//
//  Created by Agat Levi on 11/05/2022.
//

import Foundation

enum LogEventType: String {
    case login
    case signup
    case settings
    case boxState
    case userInfo
}


class Logger {
    static let instance = Logger()
    
    func logEvent(type: LogEventType, info: String) {
        let message = "\(type) :\(info)"
        print(message)
    }
}
