//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 28/02/2024.
//

import Foundation

struct TrackerCategory {
    let id: UUID
    let title: String
}

extension TrackerCategory {
    init?(from categoryCoreData: TrackerCategoryCoreData) {
        guard let title = categoryCoreData.name,
              let id = categoryCoreData.id
        else { return nil }
        self.title = title
        self.id = id
    }
}

extension TrackerCategory: Hashable {
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
