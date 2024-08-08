//
//  StatisticScreenModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 31/07/2024.
//

import Foundation

struct StatisticScreenModel {
    let title: String
    let statisticData: StatisticData
    
    struct StatisticData {
        let items: [StatisticItem]
        
        enum StatisticItem {
            case bestPeriod(StatisticElementViewModel)
            case bestDays(StatisticElementViewModel)
            case completed(StatisticElementViewModel)
            case avarage(StatisticElementViewModel)
        }
    }
    
    static let empty: StatisticScreenModel = StatisticScreenModel(title: "", statisticData: .init(items: []))

}
