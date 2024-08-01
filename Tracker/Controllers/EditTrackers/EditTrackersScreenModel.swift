//
//  EditTrackersScreenModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 01/08/2024.
//

import Foundation

struct EditTrackerScreenModel {
    
    struct TableData {
        enum Section {
            case headeredSection(header: String, cells: [Cell])
            case simpleSection(cells: [Cell])
        }
        
        enum Cell {
            case textFieldCell(TextFieldCellViewModel)
            case subtitledCell(SubtitledDetailTableViewCellViewModel)
            case emogiCell(EmojiTableViewCellViewModel)
            case colorCell(ColorTableViewCellViewModel)
        }
        
        let sections: [Section]
    }
    let title: String
    let tableData: TableData
    let daysCount: Int
    
    static let empty = EditTrackerScreenModel(title: "", tableData: TableData(sections: []), daysCount: 0)
}
