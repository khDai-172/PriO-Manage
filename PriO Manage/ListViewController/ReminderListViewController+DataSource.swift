//
//  ReminderListViewController+DataSource.swift
//  PriO Manage
//
//  Created by Khoa Dai on 08/08/2023.
//

import UIKit

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    // MARK: - Update Snapshot
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) {
        let idsFiltered = idsThatChanged.filter { id in filterReminders.contains(where: { $0.id == id }) }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filterReminders.map { $0.id })
        
        if !idsFiltered.isEmpty {
            snapshot.reloadItems(idsFiltered)
        }
        dataSource.apply(snapshot)
        headerView?.progress = progress
    }
    
    // MARK: - Retrieve the reminder item using indexOfReminder(withId:)
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        return reminders[index]
    }
    
    // MARK: - Fetch a reminder from the model to change its isComplete properties
    func completeReminder(withId id: Reminder.ID) {
        var reminder = reminder(withId: id)
        reminder.isComplete.toggle()
        updateReminder(reminder)
        updateSnapshot(reloading: [id])
    }
    
    // MARK: - Update the reminder item
    func updateReminder(_ reminder: Reminder) {
        let index = reminders.indexOfReminder(withId: reminder.id)
        // assign updated reminder item to outdated reminder item
        reminders[index] = reminder
    }
    
    // MARK: - Add a reminder
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
    }
    
    // MARK: - Delete a reminder with an ID
    func deleteReminder(with id: Reminder.ID) {
        let index = reminders.indexOfReminder(withId: id)
        reminders.remove(at: index)
    }
    
    // MARK: - Set cell's content and appearance configuration handler
    func cellRegistrationHandler(_ cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        
        let reminder = reminder(withId: id)

        // set cell content
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.textProperties.color = .prioGradientTodayEnd
        
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14)
        
        cell.contentConfiguration = contentConfiguration
        
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)]
        
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        
        // add done button to cell
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .prioGradientTodayEnd
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .whenNotEditing)
        ]
        
        // cell background config
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .clear
        cell.backgroundConfiguration = backgroundConfig
    }
    
    // MARK: - Set done button view for each cell
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        
        // custom an image object from isComplete property using Ternary Operator
        let symbolName = reminder.isComplete ? "checkmark.circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        
        // create and configure done button
        let doneButton = ReminderDoneButton()
        doneButton.id = reminder.id
        doneButton.setImage(image, for: .normal)
        doneButton.setImage(UIImage(systemName: "circle.fill"), for: .highlighted)
        doneButton.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        
        return UICellAccessory.CustomViewConfiguration(customView: doneButton, placement: .leading(displayed: .always))
    }
    
    // MARK: - Create function that implements VoiceOver
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        
        // create a name for the action using NSLocalizedString
        let actionName = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        
        // create a UIAccessibilityCustomAction
        let action = UIAccessibilityCustomAction(name: actionName) { action in
            self.completeReminder(withId: reminder.id)
            return true
        }
        return action
    }

}
