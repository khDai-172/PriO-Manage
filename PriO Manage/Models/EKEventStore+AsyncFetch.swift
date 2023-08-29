//
//  EKEventStore+AsyncFetch.swift
//  PriO Manage
//
//  Created by Khoa Dai on 29/08/2023.
//

import EventKit
import Foundation

// EKEventStore objects can access a user’s calendar events and reminders.
// The async keyword after the function’s parameters indicates that this function can execute asynchronously.
// You use continuations to wrap concurrent callback functions so that their results can be returned inline. The await keyword indicates that your task suspends until the continuation resumes.
// Call the EventKit method fetchReminders(matching:). The method passes the matching reminders to the completion handler.
// if let reminders is the shortened Swift syntax for if let reminders = reminders.
// Your function resumes execution and returns the EKReminder array. Your function resumes execution and returns the EKReminder array.

extension EKEventStore {
    
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        try await withCheckedContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    continuation.resume(returning: reminders)
                } else {
                    
                }
            }
        }
    }
}
