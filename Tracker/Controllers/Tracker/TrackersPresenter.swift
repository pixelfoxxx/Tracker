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
    func didTapFilterButton()
}

final class TrackersPresenter {
    
    var trackers: [Tracker] {
        get {
            let trackerStore = TrackerStore()
            return trackerStore.fetchTrackers()
        }
        
        set(newTrackers) {
            for tracker in newTrackers {
                guard let category = tracker.category else { continue }
                trackersByCategory[category, default: []].append(tracker)
            }
        }
    }
    
    var trackersByCategory = [TrackerCategory: [Tracker]]()
    
    var shouldShowBackgroundView: Bool {
        guard let view = view else { return false }
        return ((view.isSearching || view.isFiltering) && filteredTrackersByCategory.isEmpty) || trackers.isEmpty
    }
    
    private var completedTrackers: Set<TrackerRecord> {
        get {
            let trackerRecordsStore = TrackerRecordStore()
            var trackersRecords = trackerRecordsStore.fetchTrackerRecords()
            return Set(trackersRecords)
        }
        
        set {}
    }
    
    private weak var view: TrackersViewProtocol?
    private let analyticService = AnalyticService()
    private let router: TrackersRouterProtocol
    private var filteredTrackersByCategory = [TrackerCategory: [Tracker]]()
    private var inputFilter: Filter = .none
    private var isFiltering: Bool { inputFilter != .none }
    
    init(
        view: TrackersViewProtocol,
        router: TrackersRouterProtocol
    ) {
        self.view = view
        self.router = router
    }
    
    private func buildScreenModel() -> TrackersScreenModel {
        let categoriesWithTrackers = (view?.isFiltering == true || view?.isSearching == true) ? filteredTrackersByCategory : trackersByCategory
        let categories = Array(categoriesWithTrackers.keys)
        let sections: [TrackersScreenModel.CollectionData.Section] = categories.compactMap { category in
            let cells = categoriesWithTrackers.values
                .flatMap { $0 }
                .filter { $0.category == category }
                .compactMap { tracker -> TrackersScreenModel.CollectionData.Cell? in
                    guard let view else { return nil }
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
                                    deleteTrackerRecord(withId: trackerRecord.id)
                                    completedTrackers.remove(trackerRecord)
                                } else {
                                    addTrackerRecord(trackerRecord: trackerRecord)
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
            title: NSLocalizedString("Trackers", comment: ""),
            emptyState: backgroundState(),
            collectionData: .init(sections: sections),
            filtersButtonTitle: NSLocalizedString("Filters", comment: ""),
            addBarButtonColor: Assets.Colors.navBarItem ?? .black
        )
    }
    
    private func addTrackerRecord(trackerRecord: TrackerRecord) {
        do {
            try TrackerRecordStore().createTrackerRecord(with: trackerRecord)
            print("✅ TrackerRecord успешно добавлен")
            render(reloadData: true)
        } catch {
            print("❌ Не удалось создать TrackerRecord: \(error)")
        }
    }
    
    private func deleteTrackerRecord(withId id: UUID) {
        do {
            try TrackerRecordStore().deleteTrackerRecord(withId: id)
        } catch {
            print("Ошибка при удалении записи трекера: \(error)")
        }
    }
    
    private func backgroundState() -> BackgroundView.BackgroundState {
        guard let view = view else { return .empty }
        if trackers.isEmpty {
            return .trackersDoNotExist
        } else if view.isSearching && filteredTrackersByCategory.isEmpty {
            return .emptySearchResult
        } else {
            return .trackersDoNotExist
        }
    }
    
    private func render(reloadData: Bool = true) {
        view?.displayData(model: buildScreenModel(), reloadData: reloadData)
    }
    
    private func sendAnalyticEvent(name: AnalyticsEvent, params: [AnyHashable : Any]) {
        analyticService.report(event: name, params: params)
    }
}

extension TrackersPresenter: TrackersPresenterProtocol {
    func setup() {
        
        let trackers = TrackerStore().fetchTrackers()
        trackers.forEach { tracker in
            if let category = tracker.category {
                self.trackersByCategory[category, default: []].append(tracker)
            }
        }
        render()
    }
    
    func addTracker() {
        guard let view = view else { return }
        router.showCreateTrackerController(selectedDate: view.currentDate) { [weak self] tracker in
            guard let self = self, let category = tracker.category else { return }
            self.trackersByCategory[category, default: []].append(tracker)
            self.render(reloadData: true)
        }
    }
    
    func showSearchResults(with inputText: String) {
        self.filteredTrackersByCategory.removeAll()
        trackersByCategory.values
            .flatMap { $0 }
            .filter { $0.title.contains(inputText) }
            .forEach {
                if let category = $0.category {
                    self.filteredTrackersByCategory[category, default: []].append($0)
                }
            }
        render(reloadData: true)
    }
    
    func filterTrackers(for date: Date) {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        guard let selectedWeekday = Weekday(rawValue: weekday) else { return }
        
        filteredTrackersByCategory.removeAll()
        
        trackersByCategory.forEach { category, trackers in
            let filteredTrackers = trackers.filter {
                $0.schedule.contains(selectedWeekday) || $0.schedule.date == date
            }
            if !filteredTrackers.isEmpty {
                filteredTrackersByCategory[category] = filteredTrackers
            }
        }
        
        render(reloadData: true)
    }
    
    func didTapFilterButton() {
        sendAnalyticEvent(name: .click, params: ["screen": "Trackers", "item": "filter"])
        router.showFiltersController { [ weak self ] filter in
            guard let self else { return }
            self.inputFilter = filter
            if filter == .trackersForToday {
                self.view?.setCurrentDate(date: Date())
            }
            self.applyCurrentFilter()
        }
    }
    
    func applyCurrentFilter() {
        switch inputFilter {
        case .allTrackers:
            self.showAllTrackers()
        case .completedTrackers:
            self.showCompletedTrackers()
        case .uncompletedTrackers:
            self.showUncompletedTrackers()
        case .trackersForToday:
            self.showTrackersForToday()
        case .none:
            filteredTrackersByCategory.removeAll()
            render(reloadData: true)
        }
    }
}

private extension TrackersPresenter {
    func showAllTrackers() {
        guard let view = view else { return }
        
        filteredTrackersByCategory.removeAll()
        
        trackersByCategory.forEach { category, trackers in
            let weekday = Calendar.current.component(.weekday, from: view.currentDate)
            guard let selectedWeekday = Weekday(rawValue: weekday) else { return }
            let trackers = trackers.filter { $0.schedule.contains(selectedWeekday) }
            filteredTrackersByCategory[category] = trackers
        }
        
        render(reloadData: true)
    }
    
    func showTrackersForToday() {
        guard let view = view else { return }
        
        let weekday = Calendar.current.component(.weekday, from: view.currentDate)
        guard let selectedWeekday = Weekday(rawValue: weekday) else { return }
        
        self.filteredTrackersByCategory.removeAll()
        trackersByCategory.values
            .flatMap { $0 }
            .filter { $0.schedule.contains(selectedWeekday) }
            .forEach {
                if let category = $0.category {
                    self.filteredTrackersByCategory[category, default: []].append($0)
                }
            }
        render(reloadData: true)
    }
    
    func showCompletedTrackers() {
        guard let view = view else { return }
        filteredTrackersByCategory.removeAll()
        
        trackersByCategory.forEach { category, trackers in
            let completedTrackers = trackers.filter { tracker in
                let trackerRecord = TrackerRecord(id: tracker.id, date: view.currentDate)
                return self.completedTrackers.contains(trackerRecord)
            }
            if !completedTrackers.isEmpty {
                filteredTrackersByCategory[category] = completedTrackers
            }
        }
        
        render(reloadData: true)
    }
    
    func showUncompletedTrackers() {
        guard let view = view else { return }
        filteredTrackersByCategory.removeAll()
        
        trackersByCategory.forEach { category, trackers in
            let uncompletedTrackers = trackers.filter { tracker in
                let trackerRecord = TrackerRecord(id: tracker.id, date: view.currentDate)
                return !self.completedTrackers.contains(trackerRecord)
            }
            if !completedTrackers.isEmpty {
                filteredTrackersByCategory[category] = uncompletedTrackers
            }
        }
        
        render(reloadData: true)
    }
}
