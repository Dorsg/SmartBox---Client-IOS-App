//
//  URL++.swift
//  SmartBox
//
//  Created by Agat Levi on 27/04/2022.
//

import Foundation

extension URL {
    init?(urlString string: String) {
        guard let url = URL(string: string.trimmingCharacters(in: .whitespaces)) else {
            return nil
        }
        self = url
    }
}
