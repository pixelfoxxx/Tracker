//
//  Assembler.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 01/05/2024.
//

import UIKit

protocol AssemblerProtocol: AnyObject {
    static func buildCreateTrackerModule(selectedDate: Date, onSave: @escaping (Tracker) -> Void) -> UIViewController
}

final class Assembler: AssemblerProtocol {
    
    static func buildCreateTrackerModule(selectedDate: Date, onSave: @escaping (Tracker) -> Void) -> UIViewController {
        let addTrackerViewProtocol = AddTrackerViewController()
        let router = AddTrackerRouter(view: addTrackerViewProtocol)
        let addTrackerPresenter = AddTrackerPresenter(view: addTrackerViewProtocol, selectedDate: selectedDate, router: router, onSave: onSave)
        addTrackerViewProtocol.presenter = addTrackerPresenter
        return addTrackerViewProtocol
    }
    
    static func buildCreateActivityModule(state: CreateActivityState, selectedDate: Date, onSave: @escaping (Tracker) -> Void) -> UIViewController {
        let createActivityViewController = CreateActivityViewController()
        let router = CreateActivityRouter(view: createActivityViewController)
        let createActivityPresenter = CreateActivityPresenter(
            view: createActivityViewController,
            selectedDate: selectedDate,
            state: state, router: router, onSave: onSave)
        createActivityViewController.presenter = createActivityPresenter
        return createActivityViewController
    }
    
    static func buildScheduleModule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void) -> UIViewController {
        let vc = ScheduleViewController()
        let presenter = SchedulePresenter(view: vc, selectedDays: selectedDays, onSave: onSave)
        vc.presenter = presenter
        return vc
    }
    
    static func buildCreateCategoryModule(onSave: @escaping (TrackerCategory) -> Void) -> UIViewController {
        let view = CreateCategoryViewController()
        let presenter = CreateCategoryPresenter(view: view, onSave: onSave)
        view.presenter = presenter
        return view
        
    }
    
    static func buildCategoriesModule(state: CategoryScreenState, categories: [TrackerCategory], categoryIsChosen: @escaping (TrackerCategory) -> Void) -> UIViewController {
        let view = CategoryViewController()
        let router = CategoryRouter(view: view)
        let presenter = CategoryPresenter(view: view, state: state, categories: categories, router: router, categoryIsChosen: categoryIsChosen)
        view.presenter = presenter
        return view
    }
}
