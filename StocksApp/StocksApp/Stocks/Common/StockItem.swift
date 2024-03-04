//
//  StockItem.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

protocol StockItemProtocol {
    var shortName: String { get }
    var fullName: String { get }
    var currentValue: String { get }
    var marketValue: String { get }
    var regularMarketChange: String { get }
    var marketPercentage: String { get }
    var isNegativeMarketValue: Bool { get }
}

struct StockItem: StockItemProtocol, Identifiable {
    var id = UUID().uuidString
    let shortName: String
    let fullName: String
    let currentValue: String
    let marketValue: String
    let regularMarketChange: String
    let marketPercentage: String
    let isNegativeMarketValue: Bool

    init(quotes: QuotesModel) {
        self.shortName = quotes.shortName ?? ""
        self.fullName = quotes.longName ?? ""
        self.currentValue = String(quotes.regularMarketPrice).amountCurrencyFormat(currency: quotes.currency)
        self.marketValue = String(quotes.regularMarketPrice)
        self.regularMarketChange = quotes.regularMarketChange.formatWithSignal()
        self.marketPercentage = quotes.regularMarketChangePercent.formatWithSignal()
        self.isNegativeMarketValue = quotes.regularMarketChange < 0
    }
}
