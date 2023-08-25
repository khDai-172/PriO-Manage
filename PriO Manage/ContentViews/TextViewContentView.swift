//
//  TextViewContentView.swift
//  PriO Manage
//
//  Created by Khoa Dai on 20/08/2023.
//

import UIKit

class TextViewContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(configuration: self)
        }
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    var textView = UITextView()
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(textView, height: 400)
        textView.delegate = self
        textView.backgroundColor = nil
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainer.maximumNumberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {
            return
        }
        textView.text = configuration.text
    }
    
}

// MARK: - UITextView Delegate
extension TextViewContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? TextViewContentView.Configuration else { return }
        configuration.onChange(textView.text)
    }
}
