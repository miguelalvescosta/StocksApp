//
//  TimeInterval+Ext.swift
//  StocksApp
//
//  Created by Miguel Costa on 05.03.24.
//

import Foundation

extension TimeInterval {
    func toDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}
