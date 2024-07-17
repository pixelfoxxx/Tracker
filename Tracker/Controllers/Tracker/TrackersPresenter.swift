//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 28/02/2024.
//

import UIKit

protocol TrackersPresenterProtocol: AnyObject {
    var shouldShowBackgroundView: Bool { get }
    func setup()
    func addTracker()
    func showSearchResults(with inputText: String)
    func filterTrackers(for date: Date)
}

extension TrackersPresenter {
    func createMockCategory() -> TrackerCategory {
        let mockTracker = Tracker(id: UUID(), title: "Test Tracker", color: .red, emoji: "🚀", schedule: Schedule(weekdays: [.monday], date: nil))
        return TrackerCategory(title: "Mock Category", trackers: [mockTracker])
    }
}

final class TrackersPresenter {
    
    weak var view: TrackersViewProtocol?
    
    var categories: [TrackerCategory] = []
    
    var shouldShowBackgroundView: Bool {
        guard let view = view else { return false }
        return ((view.isSearching || view.isFiltering) && filteredCategories.isEmpty) || categories.isEmpty
    }
    
    private var completedTrackers: Set<TrackerRecord> = []
    private var filteredCategories = [TrackerCategory]()
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
    private func buildScreenModel() -> TrackersScreenModel {
        var categories = [TrackerCategory]()
        if let view,
           view.isFiltering  || view.isSearching {
            categories = filteredCategories
        } else {
            categories = self.categories
        }
        
        let sections: [TrackersScreenModel.CollectionData.Section] = categories.map { category in
            let cells: [TrackersScreenModel.CollectionData.Cell] = category.trackers.compactMap { tracker in
                guard let view = self.view else { return nil }
                let trackerRecord = TrackerRecord(id: tracker.id, date: view.currentDate)
                let isCompleted = self.completedTrackers.contains(trackerRecord)
                let daysCount = completedTrackers.filter({$0.id == tracker.id}).count
                return .trackerCell(TrackerCollectionViewCellViewModel(
                    emoji: tracker.emoji,
                    title: tracker.title,
                    isPinned: false, //MARK: - TODO
                    daysCount: daysCount,
                    color: tracker.color,
                    doneButtonHandler: { [ weak self ] in
                        guard let self else { return }
                        if view.currentDate > Date() {
                            view.showCompleteTrackerErrorAlert()
                            return
                        } else {
                            if completedTrackers.contains(trackerRecord) {
                                completedTrackers.remove(trackerRecord)
                            } else {
                                completedTrackers.insert(trackerRecord)
                            }
                        }
                        DispatchQueue.main.async {
                            self.render(reloadData: true)
                        }
                    },
                    isCompleted: isCompleted)
                )
            }
            return .headeredSection(header: category.title, cells: cells)
        }
        
        return TrackersScreenModel (
            title: "Трекеры",
            emptyState: backgroundState(),
            collectionData: .init(sections: sections),
            filtersButtonTitle: "Фильтры",
            addBarButtonColor: Assets.Colors.navBarItem ?? .black
        )
    }
    
    private func backgroundState() -> BackgroundView.BackgroundState {
        guard let view = view else { return .empty }
        if categories.isEmpty {
            return .trackersDoNotExist
        } else if ((view.isSearching || view.isFiltering) && filteredCategories.isEmpty){
            return .emptySearchResult
        } else {
            return .empty
        }
    }
    private func render(reloadData: Bool = true) {
        view?.displayData(model: buildScreenModel(), reloadData: reloadData)
    }
}

extension TrackersPresenter: TrackersPresenterProtocol {
    func setup() {
        render()
    }
    
    func addTracker() {
        guard let view else { return }
        let createTrackerController = Assembler.buildCreateTrackerModule(selectedDate: view.currentDate) { [ weak self ] tracker in
            guard let self else { return }
            categories.append(.init(title: "777", trackers: [tracker]))
            render(reloadData: true)
        }
        view.showCreateController(viewController: createTrackerController)
    }
    
    func showSearchResults(with inputText: String) {
        self.filteredCategories = categories.map { category in
            let filteredTrackers = category.trackers.filter { $0.title.localizedCaseInsensitiveContains(inputText) }
            return  TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        filteredCategories.removeAll { $0.trackers.isEmpty }

        render(reloadData: true)
    }
    
    func filterTrackers(for date: Date) {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        guard let selectedWeekday = Weekday(rawValue: weekday) else { return }
        
        filteredCategories = categories.compactMap {
            let filteredTrackers = $0.trackers.filter { $0.schedule.contains(selectedWeekday) || $0.schedule.date == date}
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: $0.title, trackers: filteredTrackers)
        }
        
        render(reloadData: true)
    }
}
