//
//  CreateActivityViewModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 14/07/2024.
//

import UIKit

struct CreateActivityScreenModel {
    struct TableData {
        
        enum Section {
            case simple(cells: [Cell])
            case headered(header: String, cells: [Cell])
            
            var cell: [Cell] {
                switch self {
                case let .simple(cells):
                    return cells
                case .headered(_, cells: let cells):
                    return cells
                }
            }
        }
        
        enum Cell {
            case textFieldCell(TextFieldCellViewModel)
            case detailCell(SubtitledDetailTableViewCellViewModel)
            case emojiCell(EmojiTableViewCellViewModel)
            case colorCell(ColorTableViewCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let tableData: TableData
    let cancelButtonTitle: String
    let createButtonTitle: String
    
    static let empty: CreateActivityScreenModel = .init(title: "", tableData: .init(sections: []), cancelButtonTitle: "", createButtonTitle: "")
}

