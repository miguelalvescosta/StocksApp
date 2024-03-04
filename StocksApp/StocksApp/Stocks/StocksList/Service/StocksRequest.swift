//
//  StocksRequest.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

enum StocksRequest {
    case summary
    case quotes(_ symbols: [String])
    case charts
}

extension StocksRequest: APIRequest {
    var path: APIPath {
        switch self {
        case .summary: return .marketSummary
        case .quotes: return .quotes
        case .charts: return .charts
        }
    }


    var method: HTTPMethod {
        switch self {
        case .summary, .charts, .quotes: return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .summary:
                return
            [
                URLQueryItem(name: "region", value: REGION)
            ]
        case let .quotes(symbols):
                return
            [
                URLQueryItem(name: "region", value: REGION),
                URLQueryItem(name: "symbols", value: symbols.joined(separator: ","))
            ]
        default:
            return nil
        }
    }
}
