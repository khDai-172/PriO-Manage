//
//  PrioError.swift
//  PriO Manage
//
//  Created by Khoa Dai on 29/08/2023.
//

import Foundation

// Types conforming to LocalizedError can provide localized messages that describe their errors and why they occur.
// The LocalizedError protocol provides a default implementation of the errorDescription property that returns a nonspecific message.
// Because LocalizedError provides a default implementation, you’re not required to implement this property. However, your users benefit from clear information about why errors occur.

enum PrioError: LocalizedError {
    case failedReadingReminders
    case reaminderHasNoDueDate
    
    var errorDescription: String? {
        switch self {
        case .failedReadingReminders:
            return NSLocalizedString("Failed to read reminders.", comment: "failed reading reminders error description")
        case .reaminderHasNoDueDate:
            return NSLocalizedString("A reminder has no due date.", comment: "reminder has no due date error description")
        }
    }
}
