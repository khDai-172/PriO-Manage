//
//  Date+Today.swift
//  PriO Manage
//
//  Created by Khoa Dai on 08/08/2023.
//

import Foundation

extension Date {
    
    var dayAndTimeText: String {
        
        // create a time text
        let timeText = formatted(date: .omitted, time: .shortened)
        
        // test whether this date is in the current calendar day
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        } else {
            // create a date text
            let dateText = formatted(.dateTime.day().month(.abbreviated))
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    var dateText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.day().month().weekday(.wide))
        }
    }
}
