//
//  AddTrackerScreenModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 01/03/2024.
//

import UIKit

struct AddTrackerScreenModel {
    let title: String
    let habitButtonTitle: String
    let eventButtonTitle: String
    let backgroundColor: UIColor
    
    static let empty: AddTrackerScreenModel = .init(
        title: "",
        habitButtonTitle: "",
        eventButtonTitle: "",
        backgroundColor: .clear)
}
