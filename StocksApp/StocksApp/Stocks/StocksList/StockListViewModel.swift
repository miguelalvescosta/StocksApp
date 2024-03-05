//
//  StockListViewModel.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

enum StockListState: Equatable {
    case initial
    case loading
    case loaded
    case refresh
    case error
}

class StockListViewModel: ObservableObject {

    @Published var state: StockListState = .initial

    private let service: StocksAPIProtocol
    var stocksSymbol: [String]?
    var stocksList: [StockItem] = []

    init(service: StocksAPIProtocol = StocksAPI()) {
        self.service = service
    }

    @MainActor
    public func fetchStocks(_ state: StockListState = .loading) async {
        self.state = state

        do {
            let result = try await service.fetchStocks(StocksRequest.summary)

            switch result {
            case let .success(response):
                stocksSymbol = response.marketSummaryAndSparkResponse.result.map { $0.symbol }
            case .failure(_):
                self.state = .error
            }
        } catch {
            self.state = .error
        }
    }

    @MainActor
    public func fetchQuotes() async {
        do {
            let result = try await service.fetchQuotes(StocksRequest.quotes(stocksSymbol ?? []))
            
            switch result {
            case let .success(response):
                stocksList = response.quoteResponse.result.map { StockItem(quotes: $0) }
                self.state = .loaded
            case .failure(_):
                self.state = .error
            }
        } catch {
            self.state = .error
        }
    }

}
