//
//  UIViewController++.swift
//  SmartBox
//
//  Created by Agat Levi on 27/04/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertViewController(title: String?, message: String?, actions: [UIAlertAction], animated: Bool, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: animated, completion: completion)
    }
}
