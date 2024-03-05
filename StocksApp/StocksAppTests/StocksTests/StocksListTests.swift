//
//  StocksListTests.swift
//  StocksAppTests
//
//  Created by Miguel Costa on 05.03.24.
//

import Foundation
import XCTest
@testable import StocksApp

final class EpisodeOverviewTests: XCTestCase {


    func test_fetch_stocks_error() async {

        let api = MockStocksAPI(stocksListResponse: .failure(.invalidData))
        let sut = StockListViewModel(service: api)
        await sut.fetchStocks()
        XCTAssertNil(sut.stocksSymbol)
        XCTAssertEqual(sut.state, .error)

    }

    func test_fetch_stocks_no_internet() async {

        let api = MockStocksAPI(stocksListResponse: .failure(.noInternet))
        let sut = StockListViewModel(service: api)
        await sut.fetchStocks()
        XCTAssertNil(sut.stocksSymbol)
        XCTAssertEqual(sut.state, .error)

    }

    func test_fetch_stocks_success() async {
        let api = MockStocksAPI(stocksListResponse: .success(createMockStocks()))
        let sut = StockListViewModel(service: api)
        await sut.fetchStocks()
        XCTAssertEqual(sut.stocksSymbol?.count, 1)
        XCTAssertEqual(sut.stocksSymbol?.first, "BTC")
    }

    func test_fetch_quotes_success() async {
        let api = MockStocksAPI(quotesResponse: .success(createMockQuotes()))
        let sut = StockListViewModel(service: api)
        await sut.fetchQuotes()
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.stocksList.count, 1)
    }

    func test_fetch_quotes_error() async {
        let api = MockStocksAPI(quotesResponse: .failure(.invalidData))
        let sut = StockListViewModel(service: api)
        await sut.fetchQuotes()
        XCTAssertEqual(sut.state, .error)
    }

    func test_fetch_stocks_list_item() async {
        let api = MockStocksAPI(quotesResponse: .success(createMockQuotes()))
        let sut = StockListViewModel(service: api)
        await sut.fetchQuotes()
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.stocksList.first?.fullName, "Bitcoin")
        XCTAssertEqual(sut.stocksList.first?.currentValue, "3.0".amountCurrencyFormat(currency: "USD"))
        XCTAssertEqual(sut.stocksList.first?.shortName, "BTC")
        XCTAssertEqual(sut.stocksList.first?.symbol, "BTC")
        XCTAssertEqual(sut.stocksList.first?.marketValue, "3.0")
        XCTAssertEqual(sut.stocksList.first?.regularMarketChange, 1.0.formatWithSignal())
        XCTAssertEqual(sut.stocksList.first?.marketPercentage, 2.0.formatWithSignal())
        XCTAssertEqual(sut.stocksList.first?.isNegativeMarketValue, false)
        XCTAssertEqual(sut.stocksList.first?.dayLowValue, 4.0.formatNumber())
        XCTAssertEqual(sut.stocksList.first?.dayHighValue, 5.0.formatNumber())
        XCTAssertEqual(sut.stocksList.first?.dayHighValue, 5.0.formatNumber())
        XCTAssertEqual(sut.stocksList.first?.fiftyTwoWeekLow, 7.0.formatNumber())
        XCTAssertEqual(sut.stocksList.first?.fiftyTwoWeekHigh, 8.0.formatNumber())
        XCTAssertEqual(sut.stocksList.first?.openValue, 6.0.formatNumber())
        XCTAssertEqual(sut.stocksList.first?.averageDailyVolume10Day, 9.0.formatNumber())
    }

    private func createMockStocks() -> StocksModel {
        StocksModel(marketSummaryAndSparkResponse: .init(result: [.init(symbol: "BTC")]))
    }

    private func createMockQuotes() -> QuoteModel {
        let result = QuotesResultModel(regularMarketChange: 1.0,
                                       regularMarketChangePercent: 2.0,
                                       regularMarketPrice: 3.0,
                                       regularMarketDayLow: 4.0,
                                       regularMarketDayHigh: 5.0,
                                       regularMarketOpen: 6.0,
                                       fiftyTwoWeekLow: 7.0,
                                       fiftyTwoWeekHigh: 8.0,
                                       averageDailyVolume10Day: 9.0,
                                       currency: "USD",
                                       symbol: "BTC",
                                       longName: "Bitcoin",
                                       shortName: "BTC")

        return QuoteModel(quoteResponse: .init(result: [result]))
    }

}


class MockStocksAPI: StocksAPIProtocol {

    let stocksListResponse: ResultResponse<StocksModel>?
    let quotesResponse: ResultResponse<QuoteModel>?

    internal init(stocksListResponse: ResultResponse<StocksModel>? = nil,
                  quotesResponse: ResultResponse<QuoteModel>? = nil) {
        self.stocksListResponse = stocksListResponse
        self.quotesResponse = quotesResponse
    }

    func fetchStocks(_ request: StocksRequest) async throws -> ResultResponse<StocksModel> {
        return stocksListResponse ?? .success(.empty)
    }

    func fetchQuotes(_ request: StocksRequest) async throws -> ResultResponse<QuoteModel> {
        return quotesResponse ?? .success(.empty)
    }

}

extension StocksModel {
    static var empty: Self {
        .init(marketSummaryAndSparkResponse: .init(result: []))
    }
}

extension QuoteModel {
    static var empty: Self {
        .init(quoteResponse: .init(result: []))
    }
}
