//
//  ScheduleScreenModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 20.02.2024.
//  
//

import Foundation

struct ScheduleScreenModel {
    struct TableData {
        enum Section {
            case simple(cells: [Cell])
            
            var cells: [Cell] {
                switch self {
                case let .simple(cells):
                    return cells
                }
            }
        }
        
        enum Cell {
            case switchCell(SwitchCellViewModel)
            case labledCell(LabledCellViewModel)
        }
        
        var sections: [Section]
    }
    
    let title: String
    let tableData: TableData
    
    static let empty: ScheduleScreenModel = .init(title: "", tableData: .init(sections: []))
}
