//
//  CreateCategoryScreenModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import Foundation

struct CreateCategoryScreenModel {
    
    struct TableData {
        enum Section {
            case simple(cells: [Cell])
        }
        
        enum Cell {
            case textFieldCell(TextFieldCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let tableData: TableData
    let doneButtonTitle: String
    
    static let empty: CreateCategoryScreenModel = CreateCategoryScreenModel(title: "", tableData: .init(sections: []), doneButtonTitle: "")
    
}
