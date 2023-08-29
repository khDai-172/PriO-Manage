//
//  EKEventStore+AsyncFetch.swift
//  PriO Manage
//
//  Created by Khoa Dai on 29/08/2023.
//

import EventKit
import Foundation

//EKEventStore objects can access a user’s calendar events and reminders.

extension EKEventStore {
    
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        
    }
}
