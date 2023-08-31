//
//  EKReminder+Reminder.swift
//  PriO Manage
//
//  Created by Khoa Dai on 31/08/2023.
//

import EventKit
import Foundation

extension EKReminder {
    func update(using reminder: Reminder, in store: EKEventStore) {
        title = reminder.title
        notes = reminder.notes
        isCompleted = reminder.isComplete
    }
}
