//
//  APIURL.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

enum APIURL: String {
    case baseURL = "https://apidojo-yahoo-finance-v1.p.rapidapi.com"

    var convertedURL: URL {
        guard let url = URL(string: rawValue) else {
            assertionFailure("Incorrect format of URL")
            return URL(string: "")!
        }

        return url
    }
}
