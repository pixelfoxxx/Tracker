//
//  AddTrackerRouter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import UIKit

protocol AddTrackerRouterProtocol: AnyObject {
    func showCreateActivityController(state:CreateActivityState, selectedDate: Date, onSave: @escaping (Tracker) -> Void)
}

final class AddTrackerRouter: AddTrackerRouterProtocol {
    
    private weak var view: AddTrackerViewProtocol?
    
    init(view: AddTrackerViewProtocol) {
        self.view = view
    }
    
    func showCreateActivityController(state:CreateActivityState, selectedDate: Date, onSave: @escaping (Tracker) -> Void) {
        guard let view = view as? UIViewController else { return }
        let createHabitController = Assembler.buildCreateActivityModule(state: state, selectedDate: selectedDate, onSave: onSave)
        view.navigationController?.pushViewController(createHabitController, animated: true)
    }
}
