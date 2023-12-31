//
//  Reminder.swift
//  PriO Manage
//
//  Created by Khoa Dai on 07/08/2023.
//

import Foundation

struct Reminder: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var dueDate: Date
    var notes:  String? = nil
    var isComplete: Bool = false
}

// extension [Reminder] { }
extension Array where Element == Reminder {
    
    // use a reminder's identifier to retrieve and update individual items in the reminders array
    func indexOfReminder(withId id: Reminder.ID) -> Self.Index {
        // get the index of the first Element that satisfies the condition in the predicate
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
extension Reminder {
    static var sampleData: [Reminder] = [
        Reminder(
            title: "Submit reinbursement report", dueDate: Date().addingTimeInterval(800.0),
            notes: "Don't forget about taxi receipts", isComplete: false),
        Reminder(
            title: "Code review", dueDate: Date().addingTimeInterval(1400.0),
            notes: "Check tech specs in shared folder", isComplete: true),
        Reminder(
            title: "Pick up new contacts", dueDate: Date().addingTimeInterval(24000.0),
            notes: "Optometrist closes at 6:00PM", isComplete: false),
        Reminder(
            title: "Add notes to retrospective", dueDate: Date().addingTimeInterval(3200.0),
            notes: "Collaborate with project manager", isComplete: true),
        Reminder(
            title: "Interview new project manager candidate, and give evaluation",
            dueDate: Date().addingTimeInterval(60000.0), notes: "Review portfolio", isComplete: false),
        Reminder(
            title: "Mock up onboarding experience", dueDate: Date().addingTimeInterval(72000.0),
            notes: "Think different", isComplete: false),
        Reminder(
            title: "Review usage analytics", dueDate: Date().addingTimeInterval(83000.0),
            notes: "Discuss trends with management", isComplete: false),
        Reminder(
            title: "Confirm group reservation", dueDate: Date().addingTimeInterval(92500.0),
            notes: "Ask about space heaters", isComplete: false),
        Reminder(
            title: "Add beta testers to TestFlight", dueDate: Date().addingTimeInterval(101000.0),
            notes: "v0.9 out on Friday", isComplete: false)
    ]
}
#endif
