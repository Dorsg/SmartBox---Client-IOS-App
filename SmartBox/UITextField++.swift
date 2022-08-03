//
//  UITextField++.swift
//  SmartBox
//
//  Created by Agat Levi on 13/04/2022.
//

import UIKit

extension UITextField {    
    func isEmpty() -> Bool {
        if let text = self.text, !text.isEmpty {
            return false
        } else {
            return true
        }
    }

}
