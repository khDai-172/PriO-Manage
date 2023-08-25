//
//  DatePickerContentView.swift
//  PriO Manage
//
//  Created by Khoa Dai on 21/08/2023.
//

import UIKit

class DatePickerContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        var onChange: (Date) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentView(self)
        }
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    var datePicker = UIDatePicker()
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {
            return
        }
        datePicker.date = configuration.date
    }
    
    @objc private func didChange(_ sender: UIDatePicker) {
        guard let configuration = configuration as? Configuration else { return }
        configuration.onChange(sender.date)
    }
}
