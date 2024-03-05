//
//  APIRequestMock.swift
//  StocksAppTests
//
//  Created by Miguel Costa on 05.03.24.
//

@testable import StocksApp
enum APIRequestMock {
    case mock
}

extension APIRequestMock: APIRequest {
    var path: APIPath {
        switch self {
        case .mock: return .marketSummary
        }
    }
    

    var method: HTTPMethod {
        switch self {
        case .mock: return .get
        }
    }
}

struct APIRequestModelMock: Decodable {
    let id: Int
    let name: String
}

extension APIPath {
}
