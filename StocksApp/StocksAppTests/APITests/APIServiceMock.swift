//
//  APIServiceMock.swift
//  StocksAppTests
//
//  Created by Miguel Costa on 05.03.24.
//

import Foundation
@testable import StocksApp
protocol APIServiceMockProtocol {
    func fetchAPIMock(_ request: APIRequestMock) async throws -> ResultResponse<[APIRequestModelMock]>
}

final class APIServiceMock: APIServiceMockProtocol {

        private let networkRequester: NetworkRequester

        init(networkRequester: NetworkRequester) {
            self.networkRequester = networkRequester
        }

        func fetchAPIMock(_ request: APIRequestMock) async throws -> ResultResponse<[APIRequestModelMock]> {
            return try await networkRequester.doRequest(request: request)
        }
}
