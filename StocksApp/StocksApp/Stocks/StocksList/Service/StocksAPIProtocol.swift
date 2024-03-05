//
//  StocksAPIProtocol.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

protocol StocksAPIProtocol {
    func fetchStocks(_ request: StocksRequest) async throws -> ResultResponse<StocksModel>
    func fetchQuotes(_ request: StocksRequest) async throws -> ResultResponse<Quote>
}
struct StocksModel: Decodable {
    let marketSummaryAndSparkResponse: MarketSummary
}

struct MarketSummary: Decodable {
    let result: [StocksSymbol]
}

struct StocksSymbol: Decodable {
    let symbol: String
}

struct Quote: Decodable {
    let quoteResponse: QuoteResponse
}

struct QuoteResponse: Decodable {
    let result: [QuotesModel]
}

struct QuotesModel: Decodable {
    let regularMarketChange, regularMarketChangePercent, regularMarketPrice: Double
    let regularMarketDayLow, regularMarketDayHigh, regularMarketOpen: Double
    let fiftyTwoWeekLow, fiftyTwoWeekHigh, averageDailyVolume10Day: Double
    let currency, symbol: String
    let longName, shortName: String?
}
