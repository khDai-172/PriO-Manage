//
//  ProgressHeraderView.swift
//  PriO Manage
//
//  Created by Khoa Dai on 25/08/2023.
//

import UIKit

class ProgressHeaderView: UICollectionReusableView {
    
    static var elementKind: String { UICollectionView.elementKindSectionHeader }
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            //Calling setNeedsLayout() invalidates the current layout and triggers an update.
            lowerviewHeightConstraint?.constant = progress * bounds.height
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }
    
    private let upperView = UIView(frame: .zero)
    private let lowerView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let percentLabel = UILabel(frame: .zero)
    private var lowerviewHeightConstraint: NSLayoutConstraint?
    private var valueFormat: String {
        NSLocalizedString("%d percent", comment: "progress percentage value format")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isAccessibilityElement = true
        accessibilityLabel = NSLocalizedString("Progress", comment: "Progress view accessbility label")
        accessibilityTraits.update(with: .updatesFrequently)
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessibilityValue = String(format: valueFormat, Int(progress * 100.0))
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
        lowerviewHeightConstraint?.constant = progress * bounds.height
        
        percentLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        percentLabel.textAlignment = .center
        percentLabel.font = UIFont.systemFont(ofSize: 50, weight: .medium)
        percentLabel.text = "\(Int(round(progress * 100.0)))%"
    }
    
    func prepareSubviews() {
        containerView.addSubview(upperView)
        containerView.addSubview(lowerView)
        containerView.insertSubview(percentLabel, aboveSubview: lowerView)
        addSubview(containerView)
        
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        upperView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Maintain a 1:1 fixed aspect ratio for the superview and container views.
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        percentLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        upperView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        upperView.bottomAnchor.constraint(equalTo: lowerView.bottomAnchor).isActive = true
        lowerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        upperView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        upperView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lowerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lowerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        // make an adjustable height constraint for the lower view
        lowerviewHeightConstraint = lowerView.heightAnchor.constraint(equalToConstant: 0)
        lowerviewHeightConstraint?.isActive = true
        
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        upperView.backgroundColor = .prioListCellBackground
        //lowerView.backgroundColor = .prioGradientTodayBegin
    }
    
    func getLowerView() -> UIView {
        return lowerView
    }
}
