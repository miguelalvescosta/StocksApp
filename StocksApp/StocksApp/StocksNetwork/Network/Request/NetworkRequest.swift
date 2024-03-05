//
//  NetworkRequest.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

struct NetworkRequest {
    var request: URLRequest

    init(apiRequest: APIRequest) {

        var urlComponents = URLComponents(string: apiRequest.url?.description ?? APIURL.baseURL.rawValue)

        urlComponents?.path = apiRequest.path.rawValue
        urlComponents?.queryItems = apiRequest.queryItems

        guard let fullURL = urlComponents?.url else {
            assertionFailure("Couldn't build the URL")
            self.request = URLRequest(url: URL(string: "")!)

            return
        }

        request = URLRequest(url: fullURL)
        request.httpMethod = apiRequest.method.rawValue
        request.timeoutInterval = apiRequest.timeoutInterval
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "*/*",
            "X-RapidAPI-Key": RapidAPIKey,
            "X-RapidAPI-Host": RapidAPIHost
        ]

        if let params = apiRequest.params,
           apiRequest.method == .post || apiRequest.method == .patch {
            let jsonData = try! JSONSerialization.data(withJSONObject: params,
                                                       options: .prettyPrinted)
            request.httpBody = jsonData
        }
    }
}
