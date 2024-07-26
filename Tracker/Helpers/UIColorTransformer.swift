//
//  UIColorTransformer.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import UIKit

@objc(UIColorTransformer)
class UIColorTransformer: NSSecureUnarchiveFromDataTransformer {

    // Definition of classes allowed to coding
    override static var allowedTopLevelClasses: [AnyClass] {
        return [UIColor.self]
    }
    
    // Ensures the transformer conforms to NSSecureCoding.
    static func supportsSecureCoding() -> Bool {
        return true
    }

    // Transformer registration
    public static func register() {
        let className = String(describing: UIColorTransformer.self)
        let name = NSValueTransformerName(className)

        let transformer = UIColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
