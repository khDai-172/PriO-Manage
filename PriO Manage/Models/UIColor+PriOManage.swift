//
//  UIColor+PriOManage.swift
//  PriO Manage
//
//  Created by Khoa Dai on 08/08/2023.
//

import UIKit

extension UIColor {
    static var prioDetailCellTint: UIColor {
        UIColor(named: "TodayDetailCellTint") ?? .tintColor
    }

    static var prioListCellBackground: UIColor {
        UIColor(named: "TodayListCellBackground") ?? .secondarySystemBackground
    }

    static var prioListCellDoneButtonTint: UIColor {
        UIColor(named: "TodayListCellDoneButtonTint") ?? .tintColor
    }

    static var prioGradientAllBegin: UIColor {
        UIColor(named: "TodayGradientAllBegin") ?? .systemFill
    }

    static var prioGradientAllEnd: UIColor {
        UIColor(named: "TodayGradientAllEnd") ?? .quaternarySystemFill
    }

    static var prioGradientFutureBegin: UIColor {
        UIColor(named: "TodayGradientFutureBegin") ?? .systemFill
    }

    static var prioGradientFutureEnd: UIColor {
        UIColor(named: "TodayGradientFutureEnd") ?? .quaternarySystemFill
    }

    static var prioGradientTodayBegin: UIColor {
        UIColor(named: "TodayGradientTodayBegin") ?? .systemFill
    }

    static var prioGradientTodayEnd: UIColor {
        UIColor(named: "TodayGradientTodayEnd") ?? .quaternarySystemFill
    }

    static var prioNavigationBackground: UIColor {
        UIColor(named: "TodayNavigationBackground") ?? .secondarySystemBackground
    }

    static var prioPrimaryTint: UIColor {
        UIColor(named: "TodayPrimaryTint") ?? .tintColor
    }

    static var prioProgressLowerBackground: UIColor {
        UIColor(named: "TodayProgressLowerBackground") ?? .systemGray
    }

    static var prioProgressUpperBackground: UIColor {
        UIColor(named: "TodayProgressUpperBackground") ?? .systemGray6
    }
}

