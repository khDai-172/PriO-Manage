//
//  EKReminder+Reminder.swift
//  PriO Manage
//
//  Created by Khoa Dai on 31/08/2023.
//

import EventKit
import Foundation

// EventKit calendar items must be associated with a calendar. The user can change their default calendar in the Settings app.
// EventKit uses a combination of alarms and the due date to determine when to remind a user of an action. Today uses only the due date. You need to remove any excess alarms from the record.

extension EKReminder {
    func update(using reminder: Reminder, in store: EKEventStore) {
        title = reminder.title
        notes = reminder.notes
        isCompleted = reminder.isComplete
        calendar = store.defaultCalendarForNewReminders()
        
    }
}
