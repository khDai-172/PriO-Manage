//
//  PrioError.swift
//  PriO Manage
//
//  Created by Khoa Dai on 29/08/2023.
//

import Foundation

// Types conforming to LocalizedError can provide localized messages that describe their errors and why they occur.
enum PrioError: LocalizedError {
    case failedReadingReminders
}
