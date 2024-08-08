//
//  EditTrackersPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 01/08/2024.
//

import UIKit

protocol EditTrackerPresenterProtocol: AnyObject {
    var isSaveEnabled: Bool { get }
    
    func setup()
    func save()
}

final class EditTrackerPresenter {
    
    typealias TableData = EditTrackerScreenModel.TableData
    var isSaveEnabled: Bool {
        !enteredActivityName.isEmpty
        && !enteredEmogi.isEmpty
        && enteredColor != nil
        && enteredCategory != nil
        && !enteredSchedule.weekdays.isEmpty
    }
    
    var tracker: Tracker
    var daysCount: Int
    
    weak var view: EditTrackerViewProtocol?
    
    private var enteredActivityName: String = "" {
        didSet { updateSaveButtonState() }
    }
    private var enteredEmogi: String = "" {
        didSet { updateSaveButtonState() }
    }
    private var enteredColor: UIColor? {
        didSet { updateSaveButtonState() }
    }
    private var enteredSchedule: Schedule = .init(weekdays: []) {
        didSet { updateSaveButtonState() }
    }
    
    private var enteredCategory: TrackerCategory? = nil {
        didSet { updateSaveButtonState() }
    }
    
    private var categories: [TrackerCategory] {
        get {
            let categoriesStore = TrackerCategoryStore()
            return categoriesStore.fetchCategories()
        }
    }
    
    private var router: EditTrackerRouterProtocol
    
    init(
        view: EditTrackerViewProtocol,
        tracker: Tracker,
        daysCount: Int,
        router: EditTrackerRouterProtocol
    ) {
        self.view = view
        self.tracker = tracker
        self.daysCount = daysCount
        self.enteredActivityName = tracker.title
        self.enteredEmogi = tracker.emoji
        self.enteredColor = tracker.color
        self.enteredSchedule = tracker.schedule
        self.enteredCategory = tracker.category
        self.router = router
    }
    
    private func buildScreenModel() -> EditTrackerScreenModel {
        return EditTrackerScreenModel(
            title: NSLocalizedString("Habit editing", comment: ""),
            tableData: buildTableData(),
            daysCount: daysCount
        )
    }
    
    private func buildTableData() -> TableData {
        return TableData(sections: [
            buildTitleSection(),
            buildCategoryAndScheduleSection(),
            createEmojiSection(),
            createColorSection()
        ])
    }
    
    private func buildTitleSection() -> TableData.Section {
        return .simpleSection(cells: [
            .textFieldCell(
                .init(
                    placeholderText: NSLocalizedString("Enter the tracker name", comment: ""),
                    inputText: tracker.title,
                    textDidChanged: { [ weak self ] inputText in
                        self?.enteredActivityName = inputText
                    }
                )
            )
        ])
    }
    
    private func buildCategoryAndScheduleSection() -> TableData.Section {
        return .simpleSection(cells: [
            .subtitledCell(.init(
                title: NSLocalizedString("Category", comment: ""),
                subtitle: enteredCategory?.title)  { [ weak self ] in
                    guard let self else { return }
                    self.showCategories(state: categories.isEmpty ? .empty : .categoriesList)
                }),
            .subtitledCell(.init(
                title: NSLocalizedString("Schedule", comment: ""),
                subtitle: createScheduleDetailInfo()) { [ weak self ] in
                    guard let self else { return }
                    self.showSchedule()
                })
        ])
    }
    
    private func createEmojiSection() -> TableData.Section {
        return .headeredSection (
            header: "Emoji",
            cells: [
                .emogiCell(
                    .init(
                        action: { [ weak self ] emogi in
                            guard let self else { return }
                            self.enteredEmogi = emogi
                        }
                    )
                )
            ]
        )
    }
    
    private func createColorSection() -> TableData.Section {
        return .headeredSection (
            header: NSLocalizedString("Color", comment: ""),
            cells: [.colorCell(.init(action: { [ weak self ] color in
                guard let self else { return }
                self.enteredColor = color
            }))])
    }
    
    private func createScheduleDetailInfo() -> String {
        let weekdays = enteredSchedule.weekdays
        let sortedWeekdays = weekdays.sorted(by: { $0.rawValue < $1.rawValue })
        
        switch weekdays.count {
        case 7:
            return NSLocalizedString("Every day", comment: "")
        case 5 where !weekdays.contains(.saturday) && !weekdays.contains(.sunday):
            return NSLocalizedString("Weekdays", comment: "")
        case 2 where weekdays.contains(.saturday) && weekdays.contains(.sunday):
            return NSLocalizedString("Weekend", comment: "")
        default:
            return sortedWeekdays.map { $0.shortName }.joined(separator: ", ")
        }
    }
    
    private func showCategories(state: CategoryScreenState) {
        router.showCategories(state: state, categories: categories) { [ weak self ] category in
            guard let self else { return }
            self.enteredCategory = category
        }
    }
    
    private func showSchedule() {
        router.showSchedule(selectedDays: enteredSchedule.weekdays) { [ weak self ] schedule in
            guard let self else { return }
            self.enteredSchedule = schedule
        }
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
    
    private func updateSaveButtonState() {
        view?.updateSaveButton(isEnabled: isSaveEnabled)
    }
    
}

extension EditTrackerPresenter: EditTrackerPresenterProtocol {
    
    func setup() {
        render()
    }
    
    func save() {
        let trackerStore = TrackerStore()
        let tracker = Tracker(id: tracker.id, title: enteredActivityName, color: enteredColor ?? .orchid, emoji: enteredEmogi, schedule: enteredSchedule, category: enteredCategory, isPinned: tracker.isPinned)
        try? trackerStore.updateTracker(with: tracker)
    }
    
}
