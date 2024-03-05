//
//  StocksDetailsTests.swift
//  StocksAppTests
//
//  Created by Miguel Costa on 05.03.24.
//

import Foundation
import XCTest
@testable import StocksApp

final class StocksDetailsTests: XCTestCase {


    func test_fetch_stocks_detail_error() async {
        let api = MockStocksDetailAPI(stockDetailsResponse: .failure(.invalidData))
        let sut = StockDetailViewModel(service: api, stockItem: createMockQuotes())
        await sut.fetchData()
        XCTAssertEqual(sut.chartData.count, 0)
        XCTAssertEqual(sut.state, .error)
    }

    func test_fetch_stocks_detail_internet() async {
        let api = MockStocksDetailAPI(stockDetailsResponse: .failure(.invalidData))
        let sut = StockDetailViewModel(service: api, stockItem: createMockQuotes())
        await sut.fetchData()
        XCTAssertEqual(sut.chartData.count, 0)
        XCTAssertEqual(sut.state, .error)
    }

    func test_fetch_stocks_detail_success() async {
        let api = MockStocksDetailAPI(stockDetailsResponse: .success(createMockStocks()))
        let sut = StockDetailViewModel(service: api, stockItem: createMockQuotes())
        await sut.fetchData()
        XCTAssertEqual(sut.chartData.count, 1)
        XCTAssertEqual(sut.state, .loaded)
    }

    func test_fetch_stocks_detail_stock_item() async {
        let api = MockStocksDetailAPI(stockDetailsResponse: .success(createMockStocks()))
        let sut = StockDetailViewModel(service: api, stockItem: createMockQuotes())
        XCTAssertEqual(sut.shortName, "BTC")
        XCTAssertEqual(sut.longName, "Bitcoin")
        XCTAssertEqual(sut.currentValue, "3.0".amountCurrencyFormat(currency: "USD"))
        XCTAssertEqual(sut.regularMarketChange, 1.0.formatWithSignal())
        XCTAssertFalse(sut.isNegativeValue)
    }

    func test_fetch_stocks_detail_tab_day() async {
        let api = MockStocksDetailAPI(stockDetailsResponse: .success(createMockStocks()))
        let sut = StockDetailViewModel(service: api, stockItem: createMockQuotes())
        XCTAssertEqual(sut.interval, IntervalTime.fiveMinute.rawValue)
        XCTAssertEqual(sut.range, RangeTime.ondeDay.rawValue)
        XCTAssertEqual(sut.chartUnit, .minute)

    }

    func test_fetch_stocks_detail_tab_week() async {
        let api = MockStocksDetailAPI(stockDetailsResponse: .success(createMockStocks()))
        let sut = StockDetailViewModel(service: api, stockItem: createMockQuotes())
        sut.selectedTimeInterval = .week
        XCTAssertEqual(sut.interval, IntervalTime.thirtyMinutes.rawValue)
        XCTAssertEqual(sut.range, RangeTime.oneWeek.rawValue)
        XCTAssertEqual(sut.chartUnit, .minute)

    }

    func test_fetch_stocks_detail_tab_month() async {
        let api = MockStocksDetailAPI(stockDetailsResponse: .success(createMockStocks()))
        let sut = StockDetailViewModel(service: api, stockItem: createMockQuotes())
        sut.selectedTimeInterval = .month
        XCTAssertEqual(sut.interval, IntervalTime.ondeDay.rawValue)
        XCTAssertEqual(sut.range, RangeTime.oneMonth.rawValue)
        XCTAssertEqual(sut.chartUnit, .day)

    }

    func test_fetch_stocks_detail_tab_ytd() async {
        let api = MockStocksDetailAPI(stockDetailsResponse: .success(createMockStocks()))
        let sut = StockDetailViewModel(service: api, stockItem: createMockQuotes())
        sut.selectedTimeInterval = .ytd
        XCTAssertEqual(sut.interval, IntervalTime.ondeDay.rawValue)
        XCTAssertEqual(sut.range, RangeTime.ydt.rawValue)
        XCTAssertEqual(sut.chartUnit, .day)

    }



    private func createMockStocks() -> StockChartModel {
        let indicators = Indicators(quote: [.init(close: [10.0], open: [20.0])])
        let result = StockChart(result: [.init(timestamp: [1000], indicators: indicators)])
        return StockChartModel(chart: result)
    }


    private func createMockQuotes() -> StockItem {
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

        return .init(quotes: result)
    }

}


class MockStocksDetailAPI: StocksDetailAPIProtocol {

    let stockDetailsResponse: ResultResponse<StockChartModel>?

    internal init(stockDetailsResponse: ResultResponse<StockChartModel>? = nil) {
        self.stockDetailsResponse = stockDetailsResponse
    }

    func fetchStockChart(_ request: StocksDetailRequest) async throws -> ResultResponse<StockChartModel> {
        return stockDetailsResponse ?? .success(.empty)
    }
}

extension StockChartModel {
    static var empty: Self {
        .init(chart: .init(result: []))
    }
}

