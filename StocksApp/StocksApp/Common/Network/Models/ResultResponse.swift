//
//  ResultResponse.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

enum ResultResponse<T> {
    case success(T)
    case failure(APIError)
}
