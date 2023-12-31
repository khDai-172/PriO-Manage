//
//  CAGradientLayer+ListStyle.swift
//  PriO Manage
//
//  Created by Khoa Dai on 28/08/2023.
//

import UIKit

// UIKit provides the CAGradientLayer class to represent a color gradient.
extension CAGradientLayer {
    
    static func gradientLayer(for listStyle: ReminderListStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors(for: listStyle)
        layer.frame = frame
        return layer
    }
    
    static func colors(for listStyle: ReminderListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch listStyle {
        case .today:
            beginColor = .prioGradientTodayBegin
            endColor = .prioGradientTodayEnd
        case .future:
            beginColor = .prioGradientFutureBegin
            endColor = .prioGradientFutureEnd
        case .all:
            beginColor = .prioGradientAllBegin
            endColor = .prioGradientAllEnd
        }
        
        return [beginColor.cgColor, endColor.cgColor]
    }
}
