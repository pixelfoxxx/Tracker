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
        let addTrackerPresenter = AddTrackerPresenter(view: addTrackerViewProtocol, selectedDate: selectedDate, onSave: onSave)
        addTrackerViewProtocol.presenter = addTrackerPresenter
        return addTrackerViewProtocol
    }
    
    static private func trackersModuleBuilder() -> UIViewController {
        let view = TrackersViewController()
        let presenter = TrackersPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func buildCreateActivityModule(state: CreateActivityState, selectedDate: Date, onSave: @escaping (Tracker) -> Void) -> UIViewController {
        let createActivityViewController = CreateActivityViewController()
        let createActivityPresenter = CreateActivityPresenter(
            view: createActivityViewController,
            selectedDate: selectedDate,
            state: state, onSave: onSave)
        createActivityViewController.presenter = createActivityPresenter
        return createActivityViewController
    }
    
    static func buildScheduleModule(selectedDays: Set<Weekday>, onSave: @escaping (Schedule) -> Void) -> UIViewController {
        let vc = ScheduleViewController()
        let presenter = SchedulePresenter(view: vc, selectedDays: selectedDays, onSave: onSave)
        vc.presenter = presenter
        return vc
    }
}
