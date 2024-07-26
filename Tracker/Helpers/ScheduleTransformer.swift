//
//  ScheduleTransformer.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import Foundation

@objc(ScheduleTransformer)
final class ScheduleTransformer: NSSecureUnarchiveFromDataTransformer {

    override static var allowedTopLevelClasses: [AnyClass] {
        [Schedule.self]
    }
    
    static func register() {
        let transformer = ScheduleTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName("ScheduleTransformer"))
    }
}
