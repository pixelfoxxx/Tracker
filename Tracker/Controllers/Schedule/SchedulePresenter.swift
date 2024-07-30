//
//  SchedulePresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 20.02.2024.
//
//

import Foundation

enum WeekDay: String {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

protocol SchedulePresenterProtocol: AnyObject {
    func setup()
    func saveSchedule()
}

final class SchedulePresenter {
    
    var onSave: (Schedule) -> Void
    
    private weak var view: ScheduleViewProtocol?
    private var days: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    private var selectedDays: Set<Weekday> = []
    
    init(
        view: ScheduleViewProtocol,
        selectedDays: Set<Weekday>,
        onSave: @escaping (Schedule) -> Void
    ) {
        self.view = view
        self.selectedDays = selectedDays
        self.onSave = onSave
    }
    
    private func buildScreenModel() -> ScheduleScreenModel {
        ScheduleScreenModel(
            title: NSLocalizedString("Schedule", comment: ""),
            tableData: .init(sections: [
                .simple(cells: days.map({
                    let day = $0.toModelWeekday
                    return .switchCell(.init(
                        text: $0.localized,
                        isOn: selectedDays.contains(day),
                        onChange: { [weak self] isOn in
                            guard let self = self else { return }
                            if isOn {
                                self.selectedDays.insert(day)
                            } else {
                                self.selectedDays.remove(day)
                            }
                        }))
                })),
                .simple(cells: [.labledCell(.init(title: NSLocalizedString("Done", comment: ""), style: .button))])
            ])
        )
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
}

extension SchedulePresenter: SchedulePresenterProtocol {
    func setup() {
        render()
    }
    
    func saveSchedule() {
        let schedule = Schedule(weekdays: selectedDays)
        onSave(schedule)
    }
}

extension WeekDay {
    var toModelWeekday: Weekday {
        switch self {
        case .monday: return .monday
        case .tuesday: return .tuesday
        case .wednesday: return .wednesday
        case .thursday: return .thursday
        case .friday: return .friday
        case .saturday: return .saturday
        case .sunday: return .sunday
        }
    }
}
