//
//  StatisticPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 31/07/2024.
//

import Foundation

protocol StatisticPresenterProtocol: AnyObject {
    func setup()
}

final class StatisticPresenter {
    
    private weak var view: StatisticViewProtocol?
    
    private var completedTrackers: [TrackerRecord] {
        get {
            let trackersRecordsStore = TrackerRecordStore()
            return trackersRecordsStore.fetchTrackerRecords()
        }
    }
    
    init(view: StatisticViewProtocol) {
        self.view = view
    }
    
    private func buildScreenModel() -> StatisticScreenModel {
        return StatisticScreenModel(
            title: NSLocalizedString("Statistic", comment: ""),
            statisticData: StatisticScreenModel.StatisticData(
                items: [
                    .bestPeriod(.init(title: NSLocalizedString("Best period", comment: ""), count: 0)),
                    .bestDays(.init(title: NSLocalizedString("Perfect days", comment: ""), count: 0)),
                    .completed(.init(title: NSLocalizedString("Completed trackers", comment: ""), count: completedTrackers.count)),
                    .avarage(.init(title: NSLocalizedString("Avarage value", comment: ""), count: 0))
                ]
            )
        )
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel())
    }
}

extension StatisticPresenter: StatisticPresenterProtocol {
    func setup() {
        render()
    }
}
