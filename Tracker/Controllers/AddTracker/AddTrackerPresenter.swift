//
//  AddTrackerPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 01/03/2024.
//

import Foundation

protocol AddTrackerPresenterProtocol: AnyObject {
    func addEvent()
    func addHabit()
    func setup()
}

final class AddTrackerPresenter {
    
    weak var view: AddTrackerViewProtocol?
    var onSave: (Tracker) -> Void
    var selectedDate: Date
    
    init(view: AddTrackerViewProtocol?, selectedDate: Date, onSave: @escaping (Tracker) -> Void) {
        self.view = view
        self.onSave = onSave
        self.selectedDate = selectedDate
    }
    
    private func buildScreenModel() -> AddTrackerScreenModel {
        AddTrackerScreenModel(
            title: "Создание трекера",
            habitButtonTitle: "Привычка",
            eventButtonTitle: "Нерегулярное событие",
            backgroundColor: .background
        )
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel())
    }
}

extension AddTrackerPresenter:  AddTrackerPresenterProtocol {
    
    func addEvent() {
        let createEventController = Assembler.buildCreateActivityModule(state: .createEvent, selectedDate: selectedDate, onSave: onSave)
        view?.showCreateActivityController(viewController: createEventController)
    }
    
    func addHabit() {
        let createHabitController = Assembler.buildCreateActivityModule(state: .createHabit, selectedDate: selectedDate, onSave: onSave)
        view?.showCreateActivityController(viewController: createHabitController)
    }
    
    func setup() {
        render()
    }
}
