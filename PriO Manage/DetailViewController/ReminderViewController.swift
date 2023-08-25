//
//  ReminderViewController.swift
//  PriO Manage
//
//  Created by Khoa Dai on 11/08/2023.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder {
        didSet {
            // call the onChange handler
            onChange(reminder)
            // trigger actions inside handler scope
        }
    }
    var workingReminder: Reminder
    var onChange: (Reminder) -> Void
    var isAddingNewReminder: Bool = false
    private var dataSource: DataSource!
    
    init(reminder: Reminder, onChange: @escaping (Reminder) -> Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange
        // set collectionview layout
        var listConfiguration =  UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        
        navigationItem.rightBarButtonItem = editButtonItem
        // register cell
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // set data source and dequeue cell
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        updateSnapshotForViewing()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Set editing view
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            prepareForEditing()
        } else {
            if isAddingNewReminder {
                onChange(workingReminder)
            } else {
                prepareForViewing()
            }
        }
    }
    
    // MARK: - set cell content and apppearance
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editableText(let text)):
            cell.contentConfiguration = titleCellConfiguration(for: cell, with: text)
        case (.date, .editableDate(let date)):
            cell.contentConfiguration = datePickerConfiguration(for: cell, with: date)
        case (.notes, .editableText(let notes)):
            cell.contentConfiguration = notesCellConfiguration(for: cell, with: notes)
        default:
            fatalError("Unexpected combination of section and row.")
        }
        cell.tintColor = .prioGradientTodayEnd
    }
    
    // MARK: - Update snapshot for Viewing
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        snapshot.appendItems([Row.header(""), Row.date, Row.time ,Row.title, Row.notes], toSection: .view)
        
        dataSource.apply(snapshot)
    }
    
    func prepareForViewing() {
        if workingReminder != reminder {
            reminder = workingReminder
            //this trigger observer property reminder at the top
        }
        updateSnapshotForViewing()
        navigationItem.leftBarButtonItem = nil
    }
    
    // MARK: - Update snapshot for Editing
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .notes])
        snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editableDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editableText(reminder.notes)], toSection: .notes)
        
        dataSource.apply(snapshot)
    }
    
    func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        updateSnapshotForEditing()
    }
    
    // MARK: - didCancelEdit function
    @objc func didCancelEdit() {
        workingReminder = reminder
        setEditing(false, animated: true)
    }
    
    // MARK: - Return section for a row
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}
