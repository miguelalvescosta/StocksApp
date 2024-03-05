//
//  StockItem.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

protocol StockItemProtocol {
    var symbol: String { get }
    var shortName: String { get }
    var fullName: String { get }
    var currentValue: String { get }
    var marketValue: String { get }
    var dayLowValue: String { get }
    var dayHighValue: String { get }
    var fiftyTwoWeekLow: String { get }
    var fiftyTwoWeekHigh: String { get }
    var averageDailyVolume10Day: String { get }
    var openValue: String { get }
    var isin: String { get }
    var regularMarketChange: String { get }
    var marketPercentage: String { get }
    var isNegativeMarketValue: Bool { get }
}

struct StockItem: StockItemProtocol, Identifiable, Hashable {
    var id = UUID().uuidString
    let symbol: String
    let shortName: String
    let fullName: String
    let currentValue: String
    let marketValue: String
    let regularMarketChange: String
    let marketPercentage: String
    let isNegativeMarketValue: Bool
    let dayLowValue: String
    let dayHighValue: String
    let fiftyTwoWeekLow: String
    let fiftyTwoWeekHigh: String
    let openValue: String
    let averageDailyVolume10Day: String
    var isin: String {
        let length = 12
        let characters = "0123456789"

        var randomIsin = ""

        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<characters.count)
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            randomIsin.append(character)
        }

        return "CH\(randomIsin)"
    }
    
    init(quotes: QuotesResultModel) {
        self.symbol = quotes.symbol
        self.shortName = quotes.shortName ?? ""
        self.fullName = quotes.longName ?? ""
        self.currentValue = String(quotes.regularMarketPrice).amountCurrencyFormat(currency: quotes.currency)
        self.marketValue = String(quotes.regularMarketPrice)
        self.regularMarketChange = quotes.regularMarketChange.formatWithSignal()
        self.marketPercentage = quotes.regularMarketChangePercent.formatWithSignal()
        self.isNegativeMarketValue = quotes.regularMarketChange < 0
        self.dayLowValue = quotes.regularMarketDayLow.formatNumber()
        self.dayHighValue = quotes.regularMarketDayHigh.formatNumber()
        self.fiftyTwoWeekLow = quotes.fiftyTwoWeekLow.formatNumber()
        self.fiftyTwoWeekHigh = quotes.fiftyTwoWeekHigh.formatNumber()
        self.averageDailyVolume10Day = quotes.averageDailyVolume10Day.formatNumber()
        self.openValue = quotes.regularMarketOpen.formatNumber()
    }
}
