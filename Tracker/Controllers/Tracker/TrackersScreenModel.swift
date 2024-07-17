//
//  TrackersScreenModel.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 17/03/2024.
//

import UIKit

struct TrackersScreenModel {
    struct CollectionData {
        enum Section {
            case headeredSection(header: String, cells: [Cell])
            
            var cells: [Cell] {
                switch self {
                case .headeredSection(_, cells: let cells):
                    return cells
                }
            }
        }
        
        enum Cell {
            case trackerCell(TrackerCollectionViewCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let title: String
    let emptyState: BackgroundView.BackgroundState
    let collectionData: CollectionData
    let filtersButtonTitle: String
    let addBarButtonColor: UIColor
    
    static let empty: TrackersScreenModel = .init(
        title: "",
        emptyState: .empty,
        collectionData: .init(sections: []),
        filtersButtonTitle: "",
        addBarButtonColor: .clear
    )
}
