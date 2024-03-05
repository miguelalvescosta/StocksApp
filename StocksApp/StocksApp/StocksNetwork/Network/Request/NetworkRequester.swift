//
//  NetworkRequester.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import Foundation

protocol NetworkRequesterProtocol {
    var session: URLSession { get }
    func requestService<T: Decodable>(request: NetworkRequest) async throws -> ResultResponse<T>
}

extension NetworkRequesterProtocol {
    func requestService<T: Decodable>(request: NetworkRequest) async throws -> ResultResponse<T> {
            let (dataResponse, response) = try await session.data(for: request.request)
            // handling errors
            if let urlResponse = response as? HTTPURLResponse {
                switch urlResponse.statusCode {
                case 0:
                    throw APIError.noInternet
                case 400...530:
                    do {
                        let error = try mapResponse(data: dataResponse, dataType: APIErrorResponse.self)
                        print(error)
                        return .failure(APIError.apiError(message: error.message ?? ""))
                    } catch {
                        print(error)
                        return .failure(APIError.networkError(message: error.localizedDescription))
                    }
                default: break
                }
            }

            do {
                let mappedResponse = try mapResponse(data: dataResponse, dataType: T.self)
                return .success(mappedResponse)
            } catch {
                print(error)
                return .failure(APIError.invalidJSON)
            }
    }

    private func mapResponse<T: Decodable>(data: Data, dataType: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

public final class NetworkRequester: NetworkRequesterProtocol {

    internal let session: URLSession

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
}

extension NetworkRequester {
    func doRequest<T: Decodable>(request: APIRequest) async throws -> ResultResponse<T> {
        return try await requestService(request: NetworkRequest(apiRequest: request))
    }
}
