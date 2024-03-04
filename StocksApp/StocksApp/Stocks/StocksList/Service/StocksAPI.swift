//
//  StocksAPI.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

final class StocksAPI: StocksAPIProtocol {
    private let networkRequester: NetworkRequester

    init(networkRequester: NetworkRequester = .init()) {
        self.networkRequester = networkRequester
    }

    func fetchStocks(_ request: StocksRequest) async throws -> ResultResponse<StocksModel> {
        return try await networkRequester.doRequest(request: request)
    }

    func fetchQuotes(_ request: StocksRequest) async throws -> ResultResponse<Quote> {
        return try await networkRequester.doRequest(request: request)
    }

    func fetchStockChart(_ request: StocksRequest) async throws -> ResultResponse<StocksModel> {
        return try await networkRequester.doRequest(request: request)
    }

}
