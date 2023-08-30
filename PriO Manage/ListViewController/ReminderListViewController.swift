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
    
    var progress: CGFloat {
        let chunkSize = 1.0 / CGFloat(filterReminders.count)
        let progress = filterReminders.reduce(0.0) {
            let chunk = $1.isComplete ? chunkSize : 0
            return $0 + chunk
        }
        return progress
    }
    
    var headerView: ProgressHeaderView?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .prioListCellBackground
        
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
        
        // Register Supplementary cell
        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: ProgressHeaderView.elementKind, handler: supplementaryRegistrationHandler)
        dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        // call snapshot
        updateSnapshot()
        
        // show data source onto the collection view
        collectionView.dataSource = dataSource
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBackground()
        changeProgressViewLayer()
    }
    
    // MARK: - Header Registration Handler
    func supplementaryRegistrationHandler(progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath) {
        headerView = progressView
    }
    
    // MARK: - CollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filterReminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    // the system calls this method when the collection view is about to display the supplementary view.
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == ProgressHeaderView.elementKind,
              let progressView = view as? ProgressHeaderView
        else { return }
        progressView.progress = progress
    }

    // MARK: - Configure collection view appearance using compositional layout
    private func listLayout() -> UICollectionViewLayout {
        // UICollectionLayoutListConfiguration creates a section in a list layout
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

    // MARK: - Refresh background function
    func refreshBackground() {
        collectionView.backgroundView = nil
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer.gradientLayer(for: listStyle, in: collectionView.frame)
        backgroundView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = backgroundView
    }
    
    // MARK: - Refresh Progress view background color
    func changeProgressViewLayer() {
        DispatchQueue.main.async {
            let gradientLayer = CAGradientLayer.gradientLayer(for: self.listStyle, in: self.headerView?.frame ?? CGRect())
            self.headerView?.getLowerView().layer.addSublayer(gradientLayer)
        }
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
    
    // MARK: - Show errors
    func showError(_ error: Error) {
        let alertTile = NSLocalizedString("Error", comment: "Error alert title")
        
    }
}

