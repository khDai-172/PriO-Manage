//
//  ReminderStore.swift
//  PriO Manage
//
//  Created by Khoa Dai on 29/08/2023.
//

import EventKit
import Foundation

// Creating a reminder store abstraction to facilitate the persistence of reminders data.
// You can’t override methods in final classes. The compiler will display a warning if you try to subclass ReminderStore.
// Create a static property named shared, and assign it a new ReminderStore.

final class ReminderStore {
    static let shared = ReminderStore()
    
    private let ekStore = EKEventStore()
}