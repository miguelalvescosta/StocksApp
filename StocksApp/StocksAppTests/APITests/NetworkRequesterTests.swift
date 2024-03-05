//
//  NetworkRequesterTests.swift
//  StocksAppTests
//
//  Created by Miguel Costa on 05.03.24.
//

@testable import StocksApp
import XCTest

class NetworkRequesterTests: XCTestCase {
    func test_success() async {

        let response =
              """
              [
                  {
                      "id": 1,
                      "name": "Jorge"
                  },
                  {
                      "id": 2,
                      "name": "Miguel"
                  }
              ]
              """
        let data = response.data(using: .utf8)!
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://google.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        let netWorkingMock = MockNetworking()
        let sut = APIServiceMock(networkRequester: .init(session: netWorkingMock.session))

        do {
            let result = try await sut.fetchAPIMock(APIRequestMock.mock)

            switch result {
            case .success(let response):
                XCTAssertEqual(response.first?.name, "Jorge")
            default:
                break
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

    }

    func test_no_internet() async {
        let response =
              """
              [
                  {
                      "id": 1,
                      "name": "Jorge"
                  },
                  {
                      "id": 2,
                      "name": "Miguel"
                  }
              ]
              """
        let data = response.data(using: .utf8)!
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://google.com")!,
                                           statusCode: 0,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        let netWorkingMock = MockNetworking()
        let sut = APIServiceMock(networkRequester: .init(session: netWorkingMock.session))

        do {
            let result = try await sut.fetchAPIMock(APIRequestMock.mock)

            switch result {
            case .failure(let error):
                XCTAssertEqual(error, APIError.noInternet)
            default:
                break
            }
        } catch {
            XCTAssertEqual(error as! APIError, APIError.noInternet)
        }

    }

    func test_api_error() async {
        let response =
              """
              {
              "message": "Error"
              }

              """
        let data = response.data(using: .utf8)!
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://google.com")!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        let netWorkingMock = MockNetworking()
        let sut = APIServiceMock(networkRequester: .init(session: netWorkingMock.session))

        do {
            let result = try await sut.fetchAPIMock(APIRequestMock.mock)

            switch result {
            case .failure(let error):
                XCTAssertEqual(error, APIError.apiError(message: "Error"))
            default:
                break
            }
        } catch {
            XCTAssertEqual(error as! APIError, APIError.apiError(message: "Error"))
        }

    }

    func test_api_invalid_json() async {
        let response =
              """
              {
              "message": "Error"
              }

              """
        let data = response.data(using: .utf8)!
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://google.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        let netWorkingMock = MockNetworking()
        let sut = APIServiceMock(networkRequester: .init(session: netWorkingMock.session))

        do {
            let result = try await sut.fetchAPIMock(APIRequestMock.mock)

            switch result {
            case .failure(let error):
                XCTAssertEqual(error, APIError.invalidJSON)
            default:
                break
            }
        } catch {
            XCTAssertEqual(error as! APIError, APIError.invalidJSON)
        }

    }

}
