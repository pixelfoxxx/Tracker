//
//  Schedule.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import Foundation

@objc(Schedule)
public class Schedule: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true

    var weekdays: Set<Weekday> = []
    var date: Date?

    init(
        weekdays: Set<Weekday>,
        date: Date? = nil
    ) {
        self.weekdays = weekdays
        self.date = date
    }

    required public init?(coder: NSCoder) {
        if let weekdaysStrRaw = coder.decodeObject(forKey: "weekdays") as? String {
            let weekdaysArr = weekdaysStrRaw.split(separator: ";")
                .compactMap { Int($0) }
                .compactMap { Weekday(rawValue: $0) }
            self.weekdays = Set(weekdaysArr)
        }
        self.date = coder.decodeObject(of: NSDate.self, forKey: "date") as Date?
    }

    public func encode(with coder: NSCoder) {
        let weekdaysArrRaw: String = weekdays.map { String($0.rawValue) }.joined(separator: ";")
        coder.encode(weekdaysArrRaw, forKey: "weekdays")
        coder.encode(date, forKey: "date")
    }
    
    func addWeekday(_ weekday: Weekday) {
        weekdays.insert(weekday)
    }

    func removeWeekday(_ weekday: Weekday) {
        weekdays.remove(weekday)
    }
    
    func contains(_ weekday: Weekday) -> Bool {
        return weekdays.contains(weekday)
    }
}

enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}
