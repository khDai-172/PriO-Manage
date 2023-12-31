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
    
    // use this property to determine if the user has granted access to their reminder data.
    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }
    
    func requestAccess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            return
        case .denied:
            throw PrioError.accessDenied
        case .notDetermined:
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else {
                throw PrioError.accessDenied
            }
        case .restricted:
            throw PrioError.accessRestricted
        @unknown default:
            throw PrioError.unknown
        }
    }
    
    func readAll() async throws -> [Reminder] {
        guard isAvailable else {
            throw PrioError.accessDenied
        }
        
        let predicate = ekStore.predicateForReminders(in: nil)
        //This predicate narrows the results to only reminder items.
        
        let ekReminders = try await ekStore.reminders(matching: predicate)
        
        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in
            do {
                return try Reminder(with: ekReminder)
            } catch PrioError.reaminderHasNoDueDate {
                return nil
            }
        }
        return reminders
    }
    
    private func read(with id: Reminder.ID) throws -> EKReminder {
        guard let ekReminder = ekStore.calendarItem(withIdentifier: id) as? EKReminder else {
            throw PrioError.failedReadingCalendarItem
        }
        return ekReminder
    }
    
    @discardableResult
    // You won’t use the identifier that this method returns in all situations. The @discardableResult attribute instructs the compiler to omit warnings in cases where the call site doesn’t capture the return value.
    func save(_ reminder: Reminder) throws -> Reminder.ID {
        guard isAvailable else {
            throw PrioError.accessDenied
        }
        let ekReminder: EKReminder
        do {
            ekReminder = try read(with: reminder.id)
        } catch {
            ekReminder = EKReminder(eventStore: ekStore)
        }
        ekReminder.update(using: reminder, in: ekStore)
        try ekStore.save(ekReminder, commit: true)
        return ekReminder.calendarItemIdentifier
    }
    
    func remove(with id: Reminder.ID) throws {
        guard isAvailable else {
            throw PrioError.accessDenied
        }
        let ekReminder = try read(with: id)
        try ekStore.remove(ekReminder, commit: true)
    }
}
