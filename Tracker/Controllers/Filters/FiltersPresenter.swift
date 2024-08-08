//
//  FiltersPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 31/07/2024.
//

import Foundation

enum Filter: String {
    case allTrackers = "allTrackers"
    case completedTrackers = "completedTrackers"
    case uncompletedTrackers = "uncompletedTrackers"
    case trackersForToday = "trackersForToday"
    case none = "none"
}
protocol FiltersPresenterProtocol: AnyObject {
    func setup()
}

final class FiltersPresenter {
    weak var view: FiltersViewProtocol?
    var onSelectFilter: (Filter) -> Void = {_ in }
    
    private var selectedFilter: Filter {
        get {
            guard let savedFilter = UserDefaults.standard.string(forKey: "selectedFilter"),
                  let filter = Filter(rawValue: savedFilter) else { return .none }
            return filter
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "selectedFilter")
        }
    }
    
    init(view: FiltersViewProtocol, onSelectFilter: @escaping (Filter) -> Void) {
        self.view = view
        self.onSelectFilter = onSelectFilter
    }
    
    private func buildScreenModel() -> FiltersScreenModel {
        return FiltersScreenModel(
            title: NSLocalizedString("Filters", comment: ""),
            tableData: .init(sections: [
                .simple(cells: [
                    .filterCell(FilterCellViewModel(
                        title: NSLocalizedString("All trackers", comment: ""),
                        filter: .allTrackers,
                        isSelected: selectedFilter == .allTrackers,
                        selectFilter: { [weak self] filter in
                            self?.selectFilter(filter)
                        }
                    )),
                    .filterCell(FilterCellViewModel(
                        title: NSLocalizedString("Trackers for today", comment: ""),
                        filter: .trackersForToday,
                        isSelected: selectedFilter == .trackersForToday,
                        selectFilter: { [weak self] filter in
                            self?.selectFilter(filter)
                        }
                    )),
                    .filterCell(FilterCellViewModel(
                        title: NSLocalizedString("Completed", comment: ""),
                        filter: .completedTrackers,
                        isSelected: selectedFilter == .completedTrackers,
                        selectFilter: { [weak self] filter in
                            self?.selectFilter(filter)
                        }
                    )),
                    .filterCell(FilterCellViewModel(
                        title: NSLocalizedString("Uncompleted", comment: ""),
                        filter: .uncompletedTrackers,
                        isSelected: selectedFilter == .uncompletedTrackers,
                        selectFilter: { [weak self] filter in
                            self?.selectFilter(filter)
                        }
                    )),
                    .filterCell(FilterCellViewModel(
                        title: NSLocalizedString("Clear", comment: ""),
                        filter: .none,
                        isSelected: false,
                        selectFilter: { [weak self] filter in
                            self?.selectFilter(filter)
                        }
                    ))
                ])
            ])
        )
    }
    
    private func selectFilter(_ filter: Filter) {
        selectedFilter = filter
        onSelectFilter(filter)
        render()
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
}

extension FiltersPresenter: FiltersPresenterProtocol {
    func setup() {
        render()
    }
}
