//
//  AnalyticService.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 31/07/2024.
//

import Foundation
import AppMetricaCore

final class AnalyticService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "3314cd4e-e9e7-4d90-8c86-a0d5ffe5ff27") else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func report(event: AnalyticsEvent, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event.rawValue, parameters: params, onFailure: { (error) in
            print("DID FAIL REPORT EVENT: %@", error.localizedDescription)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

enum AnalyticsEvent: String {
    case open = "Open"
    case close = "Close"
    case click = "Click"
}
