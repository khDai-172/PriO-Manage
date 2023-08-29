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
// You’ll create a single instance of your class to use throughout your app.

final class ReminderStore {
    static let shared = ReminderStore()
    
}
