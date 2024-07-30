//
//  TrackersRouter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import UIKit

protocol TrackersRouterProtocol: AnyObject {
    func showCreateTrackerController(selectedDate: Date, onSave: @escaping (Tracker) -> Void)
    func showFiltersController(onSelectFilter: @escaping (Filter) -> Void)
}

final class TrackersRouter: TrackersRouterProtocol {
    
    private weak var view: TrackersViewProtocol?
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
    func showCreateTrackerController(selectedDate: Date, onSave: @escaping (Tracker) -> Void) {
        guard let view = view as? UIViewController else { return }
        let createTrackerController = Assembler.buildCreateTrackerModule(selectedDate: selectedDate, onSave: onSave)
        let nc = UINavigationController(rootViewController: createTrackerController)
        view.navigationController?.present(nc, animated: true)
    }
    
    func showFiltersController(onSelectFilter: @escaping (Filter) -> Void) {
        guard let view = view as? UIViewController else { return }
        let filtersController = Assembler.buildFiltersController(onSelectFilter: onSelectFilter)
        let nc = UINavigationController(rootViewController: filtersController)
        view.navigationController?.present(nc, animated: true)
    }
}
