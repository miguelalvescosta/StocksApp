//
//  Collection+Ext.swift
//  StocksApp
//
//  Created by Miguel Costa on 05.03.24.
//

import Foundation
extension Array where Element == StocksLinearChartData {
    var isLastValueSmallerThanFirst: Bool {
        guard let firstValue = self.first?.value, let lastValue = self.last?.value else {
            return false
        }
        return lastValue < firstValue
    }
}

extension Collection where Element == StockChartResult {
    func timeStamps() -> [Int] {
        return flatMap { $0.timestamp }
    }

    func chartQuotes() -> [Double] {
        return flatMap {  $0.indicators.quote.first?.close.compactMap { $0 } ?? [] }
    }

    func toStocksLinearChartData() -> [StocksLinearChartData] {
            return zip(timeStamps(), chartQuotes()).map { (timestamp, close) in
                StocksLinearChartData(value: close, timeInterval: TimeInterval(timestamp))
            }
        }
}
