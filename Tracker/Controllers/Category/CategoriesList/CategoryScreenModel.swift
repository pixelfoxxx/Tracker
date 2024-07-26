//
//  CategoryScreenModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import Foundation

struct CategoryScreenModel {
    struct TableData {
        enum Section {
            case simpleSection(cells: [Cell])
        }
        
        enum Cell {
            case labledCell(LabeledCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let tableData: TableData
    let buttonTitle: String
    
    static let empty: CategoryScreenModel = CategoryScreenModel(title: "", tableData: TableData(sections: []), buttonTitle: "")
}
