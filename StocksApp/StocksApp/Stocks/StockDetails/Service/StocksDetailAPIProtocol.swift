//
//  StocksDetailAPIProtocol.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

protocol StocksDetailAPIProtocol {
    func fetchStockChart(_ request: StocksDetailRequest) async throws -> ResultResponse<StockChartModel>
}

struct StockChartModel: Decodable {
    let chart: StockChart
}

struct StockChart: Decodable {
    let result: [StockChartResult]
}

struct StockChartResult: Decodable {
    let timestamp: [Int]
    let indicators: Indicators
}

struct Indicators: Decodable {
    let quote: [ChartQuote]
}

struct ChartQuote: Decodable {
    let close, open: [Double?]
}
