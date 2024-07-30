//
//  FiltersScreenModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 31/07/2024.
//

import Foundation

struct FiltersScreenModel {
    struct TableData {
        enum Section {
            case simple(cells: [Cell])
        }
        
        enum Cell {
            case filterCell(FilterCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let tableData: TableData
    
    static let empty: FiltersScreenModel = .init(title: "", tableData: .init(sections: []))
}
