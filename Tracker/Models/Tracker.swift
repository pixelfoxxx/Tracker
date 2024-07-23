//
//  Tracker.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 28/02/2024.
//

import UIKit

struct Tracker {
    
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
    let category: TrackerCategory?
}

extension Tracker {
    init?(from trackerEntity: TrackerCoreData) {
        let id = trackerEntity.id
        let title = trackerEntity.title
        let emoji = trackerEntity.emoji
        
        guard let color = trackerEntity.color,
              let schedule = trackerEntity.schedule,
              let category = trackerEntity.category
        else { return nil }
        self.id = id
        self.title = title
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.category = .init(from: category)
    }
}
