//
//  StocksDetailAPI.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

final class StocksDetailAPI: StocksDetailAPIProtocol {

    private let networkRequester: NetworkRequester

    init(networkRequester: NetworkRequester = .init()) {
        self.networkRequester = networkRequester
    }

    func fetchStockChart(_ request: StocksDetailRequest) async throws -> ResultResponse<StockChartModel> {
        return try await networkRequester.doRequest(request: request)
    }

}
