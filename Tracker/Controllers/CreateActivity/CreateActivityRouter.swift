//
//  CreateActivityRouter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import UIKit

protocol CreateActivityRouterProtocol: AnyObject {
    func showSchedule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void)
    func showCategories(state: CategoryScreenState, categories: [TrackerCategory], categoryIsChosen: @escaping (TrackerCategory) -> Void)
}

final class CreateActivityRouter: CreateActivityRouterProtocol {
    
    private weak var view: CreateActivityViewProtocol?
    
    init(view: CreateActivityViewProtocol) {
        self.view = view
    }
    
    func showSchedule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void) {
        guard let view = view as? UIViewController else { return }
        let vc = Assembler.buildScheduleModule(selectedDays: selectedDays, onSave: onSave)
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCategories(state: CategoryScreenState, categories: [TrackerCategory], categoryIsChosen: @escaping (TrackerCategory) -> Void) {
        guard let view = view as? UIViewController else { return }
        let vc = Assembler.buildCategoriesModule(state: state, categories: categories, categoryIsChosen: categoryIsChosen)
        view.navigationController?.pushViewController(vc, animated: true)
    }
}

