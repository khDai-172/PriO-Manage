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
    
    case accessDenied
    case accessRestricted
    case failedReadingCalendarItem
    case failedReadingReminders
    case reaminderHasNoDueDate
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return NSLocalizedString("The app doesn't have permission to read reminders.", comment: "access denied error description")
        case .accessRestricted:
            return NSLocalizedString("This device doesn't allow access to reminders.", comment: "access restricted error description")
        case .failedReadingCalendarItem:
            return NSLocalizedString("Failed to read a calendar item.", comment: "failed reading calendar item error description")
        case .failedReadingReminders:
            return NSLocalizedString("Failed to read reminders.", comment: "failed reading reminders error description")
        case .reaminderHasNoDueDate:
            return NSLocalizedString("A reminder has no due date.", comment: "reminder has no due date error description")
        case .unknown:
            return NSLocalizedString("An unknown error occured.", comment: "unknown error description")
        }
    }
}
