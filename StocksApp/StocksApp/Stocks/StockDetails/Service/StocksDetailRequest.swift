//
//  StocksDetailRequest.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

enum IntervalTime: String {
    case fiveMinute = "5m"
    case thirtyMinutes = "30m"
    case ondeDay = "1d"
    case oneWeek = "1wk"
    case oneMonth = "1mo"
}

enum RangeTime: String {
    case ondeDay = "1d"
    case oneWeek = "5d"
    case oneMonth = "1mo"
    case ydt = "ytd"
}

enum StocksDetailRequest {
    case chart(_ queryParams: ChartQueryParms)
}

extension StocksDetailRequest: APIRequest {
    var path: APIPath {
        switch self {
        case .chart: return .charts
        }
    }


    var method: HTTPMethod {
        switch self {
        case .chart: return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .chart(queryParams):
            [
                URLQueryItem(name: "region", value: REGION),
                URLQueryItem(name: "interval", value: queryParams.interval),
                URLQueryItem(name: "range", value: queryParams.range),
                URLQueryItem(name: "symbol", value: queryParams.symbol)
            ]
        }
    }
}
