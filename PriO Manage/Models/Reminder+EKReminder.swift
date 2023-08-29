//
//  Reminder+EKReminder.swift
//  PriO Manage
//
//  Created by Khoa Dai on 29/08/2023.
//

import EventKit
import Foundation

// If a reminder has an alarm, the system presents a notification to the user when the reminder is due.
extension Reminder {
    init(with ekReminder: EKReminder) throws {
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else {
            throw PrioError.reaminderHasNoDueDate
        }
        id = ekReminder.calendarItemIdentifier
    }
}
