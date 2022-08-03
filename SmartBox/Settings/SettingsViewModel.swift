//
//  SettingsViewModel.swift
//  SmartBox
//
//  Created by Agat Levi on 20/04/2022.
//

import Foundation

class SettingsViewModel {
    //Titles:
    let boxIdTitleText: String
    let ThresholdTitleText: String
    let currentWeightTitleText: String
    let ebayProductLinkTitleText: String
    let ebayAccountTitleText: String
    let submitButtonText: String
    
    //Values:
    var boxId: String?
    var threshold: Int?
    var currentWeight: String?
    var productLink: String?
    
    init() {
        boxIdTitleText = "Box ID"
        ThresholdTitleText = "Threshold"
        currentWeightTitleText = "Current Weight"
        ebayProductLinkTitleText = "product link"
        ebayAccountTitleText = "eBay account"
        submitButtonText = "Submit"
    }
    
}
