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
    
    init(view: AddTrackerViewProtocol?) {
        self.view = view
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
        // TODO: - Add logic
    }
    
    func addHabit() {
        // TODO: - Add logic
    }
    
    func setup() {
        render()
    }
}
