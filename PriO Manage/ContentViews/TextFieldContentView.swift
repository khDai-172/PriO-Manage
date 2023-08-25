//
//  TextFieldContentView.swift
//  PriO Manage
//
//  Created by Khoa Dai on 17/08/2023.
//

import UIKit

/// create an UIView object conformed to UIContentView, which signals that this view renders the content and styling that you define within a configuration

class TextFieldContentView: UIView, UIContentView {
    
    // Create an inner structure that conforms to UIContentConfiguration. You'll use the TextfieldContentView.ContentConfiguration type to customize the content of your configuration and your view.
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(configuration: self)
        }
        // The initializer for TextFieldContentView takes a UIContentConfiguration. This UIContentConfiguration, however, has a string that represents the content packaged inside the text field.
    }
    
    var configuration: UIContentConfiguration {
        // Add a disSet observer that calls the new configure method to the configuration preoperty. Whenever the configuration changes, you'll update the user interface to reflect the current state
        didSet {
            configure(configuration: configuration)
        }
    }
    
    let textField = UITextField()
    
    // Fix the view's preferred minimum size for an accessible control. This property allow a custom view to communicate its preferred size to the layout system.
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: 0, height: 100)
//    }
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        self.addPinnedSubview(textField, insets: UIEdgeInsets(top: 22, left: 16, bottom: 22, right: 16))
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {
            return
        }
        textField.text = configuration.text
    }
    
    // invoke onChange handler
    @objc private func didChange(_ sender: UITextField) {
        guard let configuration = configuration as? TextFieldContentView.Configuration else { return }
        configuration.onChange(sender.text ?? "")
    }
}
