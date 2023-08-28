//
//  CAGradientLayer+ListStyle.swift
//  PriO Manage
//
//  Created by Khoa Dai on 28/08/2023.
//

import UIKit

// UIKit provides the CAGradientLayer class to represent a color gradient.
extension CAGradientLayer {
    
    static func colors(for listStyle: ReminderListStyle) -> [CGColor] {
        let beginColr: UIColor
        let endColor: UIColor
        
        switch listStyle {
        case .today:
            beginColr = .prioGradientTodayBegin
            endColor = .prioGradientTodayEnd
        case .future:
            beginColr = .prioGradientFutureBegin
            endColor = .prioGradientFutureEnd
        case .all:
            beginColr = .prioGradientAllBegin
            endColor = .prioGradientAllEnd
        }
    }
}
