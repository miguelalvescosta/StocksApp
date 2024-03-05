//
//  StockDetailViewModel.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation
import Combine

struct ChartQueryParms {
    let interval: String
    let range: String
    let symbol: String
}

enum StockDetailState: Equatable {
    case initial
    case loading
    case loaded
    case chartLoading
    case error
}

enum StockTimeInterval: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case ytd = "YTD"
    var id: Self { self }
}

class StockDetailViewModel: ObservableObject {

    @Published var state: StockDetailState = .initial
    @Published var selectedTimeInterval: StockTimeInterval = .day
    @Published var isChartLoading: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    private let service: StocksDetailAPIProtocol
    internal var stockItem: StockItemProtocol
    var chartData: [StocksLinearChartData] = []

    var shortName: String {
        stockItem.shortName
    }

    var longName: String {
        stockItem.fullName
    }

    var currentValue: String {
        stockItem.currentValue
    }

    var regularMarketChange: String {
        stockItem.regularMarketChange
    }

    var isin: String {
        stockItem.isin
    }

    var isNegativeValue: Bool {
        stockItem.isNegativeMarketValue
    }

    var interval: String {
        switch selectedTimeInterval {
        case .day:
            IntervalTime.fiveMinute.rawValue
        case .week:
            IntervalTime.thirtyMinutes.rawValue
        case .month:
            IntervalTime.ondeDay.rawValue
        case .ytd:
            IntervalTime.ondeDay.rawValue
        }
    }

    var range: String {
        switch selectedTimeInterval {
        case .day:
            RangeTime.ondeDay.rawValue
        case .week:
            RangeTime.oneWeek.rawValue
        case .month:
            RangeTime.oneMonth.rawValue
        case .ytd:
            RangeTime.ydt.rawValue
        }
    }

    var chartUnit: Calendar.Component {
        switch selectedTimeInterval {
        case .day:
                .minute
        case .week:
                .minute
        case .month:
                .day
        case .ytd:
                .day
        }
    }

    init(service: StocksDetailAPIProtocol = StocksDetailAPI(),
         stockItem: StockItemProtocol) {
        self.service = service
        self.stockItem = stockItem
        bind()
    }

    private func bind() {
        $selectedTimeInterval
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.fetchData(.chartLoading)
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    public func fetchData(_ state: StockDetailState = .loading) async {
        self.state = state
        isChartLoading = state == .chartLoading
        do {
            let request = StocksDetailRequest.chart(.init(interval: interval,
                                                          range: range,
                                                          symbol: stockItem.symbol))
            let result = try await service.fetchStockChart(request)

            switch result {
            case let .success(response):
                chartData = response.chart.result.toStocksLinearChartData()
                isChartLoading = false
                self.state = .loaded
            case .failure(_):
                self.state = .error
                isChartLoading = false
            }
        } catch {
            self.state = .error
            isChartLoading = false
        }
    }
}

extension StockDetailViewModel {
    var stockInfoFirstColumn: [StockInfoWidgetItem] {
        [
            StockInfoWidgetItem(value: stockItem.openValue, title: "Open"),
            StockInfoWidgetItem(value: stockItem.dayHighValue, title: "High"),
            StockInfoWidgetItem(value: stockItem.dayLowValue, title: "Low"),
        ]
    }

    var stockInfoSecondColumn: [StockInfoWidgetItem] {
        [
            StockInfoWidgetItem(value: stockItem.fiftyTwoWeekHigh, title: "52W H"),
            StockInfoWidgetItem(value: stockItem.fiftyTwoWeekLow, title: "52W L"),
            StockInfoWidgetItem(value: stockItem.averageDailyVolume10Day, title: "Avg10d Vol"),
        ]
    }
}
