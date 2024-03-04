//
//  APIPath.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

enum APIPath {
    case marketSummary
    case quotes
    case charts

    var rawValue: String {
        switch self {
        case .marketSummary: return "/market/v2/get-summary"
        case .quotes: return "/market/v2/get-quotes"
        case .charts: return "/stock/v3/get-chart"
        }
    }
}
