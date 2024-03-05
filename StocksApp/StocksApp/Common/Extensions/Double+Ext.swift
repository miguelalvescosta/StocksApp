//
//  Double+Ext.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

extension Double {
    func formatWithSignal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let numberFormatted = formatter.string(from: NSNumber(value: self)) ?? ""

        return "\(self >= 0 ? "+" : "")\(numberFormatted)"
    }

    func formatNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        var formattedNumber = ""
        
        if abs(self) >= 1_000_000 {
            let millions = self / 1_000_000
            formattedNumber = formatter.string(from: NSNumber(value: millions)) ?? ""
            formattedNumber += "M"
        } else {
            formattedNumber = formatter.string(from: NSNumber(value: self)) ?? ""
        }

        return formattedNumber
    }
}
