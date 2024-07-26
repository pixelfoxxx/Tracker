//
//  AddTrackerPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 01/03/2024.
//

import Foundation

protocol AddTrackerPresenterProtocol: AnyObject {
    func createTracker(state: CreateActivityState)
    func setup()
}

final class AddTrackerPresenter {

    var onSave: (Tracker) -> Void
    var selectedDate: Date
    
    private weak var view: AddTrackerViewProtocol?
    private var router: AddTrackerRouterProtocol
    
    init(
        view: AddTrackerViewProtocol?,
        selectedDate: Date,
        router: AddTrackerRouterProtocol,
        onSave: @escaping (Tracker) -> Void
    ) {
        self.view = view
        self.onSave = onSave
        self.router = router
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

extension AddTrackerPresenter: AddTrackerPresenterProtocol {
    func createTracker(state: CreateActivityState) {
        router.showCreateActivityController(state: state, selectedDate: selectedDate, onSave: onSave)
    }
    
    func setup() {
        render()
    }
}
