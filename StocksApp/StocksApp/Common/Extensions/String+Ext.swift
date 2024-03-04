//
//  String+Ext.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

extension String {
    func amountCurrencyFormat(currency: String) -> String {
        guard let number = Double(self) else {
            return "0.0"
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.locale = .current

        guard let formattedAmount = formatter.string(from: NSNumber(value: number)) else {
            return "0.0"
        }

        return formattedAmount
    }
}
