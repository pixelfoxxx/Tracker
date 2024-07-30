//
//  CreateActivityPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 14/07/2024.
//

import UIKit

enum CreateActivityState {
    case createHabit
    case createEvent
}

protocol CreateActivityPresenterProtocol: AnyObject {
    var isSaveEnabled: Bool { get }
    var selectedDate: Date { get }
    func setup()
    func createActivity(for date: Date)
}

final class CreateActivityPresenter {
    
    typealias TableData = CreateActivityScreenModel.TableData
    
    var selectedDate: Date
    
    var onSave: (Tracker) -> Void
    
    var isSaveEnabled: Bool {
        !enteredActivityName.isEmpty
        && !enteredEmoji.isEmpty
        && enteredColor != nil
        && enteredCategory != nil
        && (state == .createEvent || !enteredSchedule.weekdays.isEmpty)
        
    }
    
    private var trackersStore = TrackerStore()
    private var router: CreateActivityRouterProtocol
    private var state: CreateActivityState?
    private weak var view: CreateActivityViewProtocol?
    private var categories: [TrackerCategory] {
        get {
            let categoriesStore = TrackerCategoryStore()
            return categoriesStore.fetchCategories()
        }
    }
    
    private var enteredActivityName: String = "" {
        didSet { updateSaveButtonState() }
    }
    private var enteredEmoji: String = "" {
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
    
    //MARK: - init
    
    init(
        view: CreateActivityViewProtocol,
        selectedDate: Date,
        state: CreateActivityState,
        router: CreateActivityRouterProtocol,
        onSave: @escaping (Tracker) -> Void
    ) {
        self.view = view
        self.state = state
        self.onSave = onSave
        self.router = router
        self.selectedDate = selectedDate
    }
    
    private func buildScreenModel() -> CreateActivityScreenModel {
        let title: String = {
            switch self.state {
            case .createHabit:
                NSLocalizedString("New habit", comment: "")
            case .createEvent:
                NSLocalizedString("New irregular event", comment: "")
            case nil:
                ""
            }
        }()
        
        let sections: [TableData.Section] = [
            createActivityNameSection(),
            createActivitySettingsSection(),
            createEmojiSection(),
            createColorSection()
        ]
        
        return CreateActivityScreenModel(
            title: title,
            tableData: .init(sections: sections),
            cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
            createButtonTitle: NSLocalizedString("Create", comment: ""))
    }
    
    private func createEmojiSection() -> TableData.Section {
        return .headered(
            header: NSLocalizedString("Emoji", comment: ""),
            cells: [
                .emojiCell(
                    .init(
                        action: { [ weak self ] emoji in
                            guard let self else { return }
                            self.enteredEmoji = emoji
                        }
                    )
                )
            ]
        )
    }
    
    private func createColorSection() -> TableData.Section {
        return .headered(
            header: NSLocalizedString("Color", comment: ""),
            cells: [.colorCell(.init(action: { [ weak self ] color in
                guard let self else { return }
                self.enteredColor = color
            }))])
    }
    
    private func createActivityNameSection() -> TableData.Section {
        return .simple(cells: [
            .textFieldCell(.init(
                placeholderText: NSLocalizedString("Enter the tracker name", comment: ""),
                inputText: enteredActivityName,
                textDidChanged: { [ weak self ] inputText in
                    guard let self else { return }
                    self.enteredActivityName = inputText
                }))
        ])
    }
    
    private func createActivitySettingsSection() -> TableData.Section {
        let categoryCell: TableData.Cell = .detailCell(.init(
            title: NSLocalizedString("Category", comment: ""),
            subtitle: enteredCategory?.title ?? "",
            action: { [ weak self ] in
                guard let self else { return }
                self.showCategories(state: categories.isEmpty ? .empty : .categoriesList)
                
            }))
        
        let scheduleCell: TableData.Cell = .detailCell(SubtitledDetailTableViewCellViewModel(
            title: NSLocalizedString("Schedule", comment: ""),
            subtitle: createScheduleDetailInfo(),
            action: { [ weak self ] in
                guard let self else { return }
                self.showSchedule()
            }))
        
        var activitySettingsCells: [TableData.Cell] = []
        
        activitySettingsCells.append(categoryCell)
        if state == .createHabit {
            activitySettingsCells.append(scheduleCell)
        }
        
        return.simple(cells: activitySettingsCells)
    }
    
    private func render() {
        view?.displayData(screenModel: buildScreenModel(), reloadTableData: true)
    }
    
    private func showSchedule() {
        router.showSchedule(selectedDays: enteredSchedule.weekdays) { [ weak self ] schedule in
            guard let self else { return }
            self.enteredSchedule = schedule
        }
    }
    
    private func showCategories(state: CategoryScreenState) {
        router.showCategories(state: state, categories: categories) { [ weak self ] category in
            guard let self else { return }
            self.enteredCategory = category
        }
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
    
    private func updateSaveButtonState() {
        view?.updateSaveButton(isEnabled: isSaveEnabled)
    }
}

extension CreateActivityPresenter: CreateActivityPresenterProtocol {
    
    func setup() {
        render()
    }
    
    func createActivity(for date: Date) {
        let schedule: Schedule
        if state == .createEvent {
            schedule = .init(weekdays: enteredSchedule.weekdays, date: Calendar.current.startOfDay(for: date))
        } else {
            schedule = .init(weekdays: enteredSchedule.weekdays)
        }
        
        let tracker = Tracker(
            id: UUID(),
            title: enteredActivityName,
            color: enteredColor ?? .clear,
            emoji: enteredEmoji,
            schedule: schedule,
            category: enteredCategory
        )
        
        do {
            try trackersStore.createTracker(with: tracker)
        } catch {
            print("❌❌❌ Не удалось преобразовать Tracker в TrackerCoreData")
        }
        
        onSave(tracker)
    }
}
