//
//  ProgressHeraderView.swift
//  PriO Manage
//
//  Created by Khoa Dai on 25/08/2023.
//

import UIKit

class ProgressHeaderView: UICollectionReusableView {
    
    var progress: CGFloat = 0
    
    private let upperView = UIView(frame: .zero)
    private let lowerView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    
    func prepareSubviews() {
        containerView.addSubview(upperView)
        containerView.addSubview(lowerView)
        addSubview(containerView)
        
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        upperView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
}
