//
//  PrioError.swift
//  PriO Manage
//
//  Created by Khoa Dai on 29/08/2023.
//

import Foundation

// Types conforming to LocalizedError can provide localized messages that describe their errors and why they occur.
// The LocalizedError protocol provides a default implementation of the errorDescription property that returns a nonspecific message.
enum PrioError: LocalizedError {
    case failedReadingReminders
    
    var errorDescription: String? {
        switch self {
        case .failedReadingReminders:
            return NSLocalizedString("Failed to read reminders.", comment: "failed reading reminders error description")
        }
    }
}
