//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 28/02/2024.
//

import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
}

extension TrackerRecord {
    init?(from trackerRecordCoreData: TrackerRecordCoreData) {
        guard let id = trackerRecordCoreData.id,
              let date = trackerRecordCoreData.date
        else { return nil }
        self.id = id
        self.date = date
    }
}
