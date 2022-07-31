//
//  String++.swift
//  SmartBox
//
//  Created by Agat Levi on 25/05/2022.
//

import Foundation


extension String {
    func isValidEmail() -> Bool {
        if self.contains("@") && self.contains("."){
            return true
        } else {
            return false
        }
    }
}
