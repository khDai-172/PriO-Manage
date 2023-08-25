//
//  ReminderViewController+CellConfiguration.swift
//  PriO Manage
//
//  Created by Khoa Dai on 15/08/2023.
//

import UIKit

/// Configuration methods

extension ReminderViewController {
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        return contentConfiguration
    }
    
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .title1)
        contentConfiguration.textProperties.color = .black
        return contentConfiguration
    }
    
    // set text in cell
    func text(for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dateText
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        case .notes: return reminder.notes
        default:
            return nil
        }
    }
    
    // title cell content configuring function in Detail View
    func titleCellConfiguration(for cell: UICollectionViewListCell,
                            with title: String?) -> TextFieldContentView.Configuration {
        var textFieldConfiguration = cell.textFieldConfiguration()
        textFieldConfiguration.text = title
        textFieldConfiguration.onChange = { [weak self] title in
            self?.workingReminder.title = title
        }
        return textFieldConfiguration
    }
    
    // notes cell content configuring function in Detail View
    func notesCellConfiguration(for cell: UICollectionViewListCell,
                                with text: String?) -> TextViewContentView.Configuration {
        var textViewConfiguration = cell.textViewConfiguration()
        textViewConfiguration.text = text
        textViewConfiguration.onChange = { [weak self] note in
            self?.workingReminder.notes = note
        }
        return textViewConfiguration
    }
    
    // date cell content configuring function in Detail View
    func datePickerConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DatePickerContentView.Configuration {
        var datePickerConfiguration = cell.datePickerConfiguration()
        datePickerConfiguration.date = date
        datePickerConfiguration.onChange = { [weak self] date in
            self?.workingReminder.dueDate = date
        }
        return datePickerConfiguration
    }
}
