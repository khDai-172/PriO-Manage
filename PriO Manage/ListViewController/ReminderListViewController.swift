//
//  ViewController.swift
//  PriO Manage
//
//  Created by Khoa Dai on 07/08/2023.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    var listStyle: ReminderListStyle = .today
    
    var filterReminders: [Reminder] {
        
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }.sorted { $0.dueDate < $1.dueDate }
    }

    let listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name
    ])
    
    var headerView: ProgressHeaderView?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView layout
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // Segmented Control
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.prioGradientTodayEnd]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        
        // Navigaiton Item
        navigationItem.titleView = listStyleSegmentedControl
        
        // UIBarButton
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        
        // Register cell
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // connect diffable data source to the collection view by passing in the collection view to its initializer
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            // dequeue and return a cell using the cell registration
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        // call snapshot
        updateSnapshot()
        
        // show data source onto the collection view
        collectionView.dataSource = dataSource
        
    }
    
    // MARK: - CollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filterReminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }

    // MARK: - Configure collection view appearance using compositional layout
    private func listLayout() -> UICollectionViewLayout {
        // UICollectionLayoutListConfiguration creates a section in a list layout
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .prioNavigationBackground
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

    // MARK: - Push DetailView For Reminder
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = reminder(withId: id)
        let detailViewController = ReminderViewController(reminder: reminder) {
            // this is the handler triggered when the reminder observer sees changes and calls the onChange handler
            [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Create a function to generate SwipeActionConfiguration object fopr each cell
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteReminder(with: id)
            self?.updateSnapshot()
            // call the completion handler
            completion(false)
        }
        deleteAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

