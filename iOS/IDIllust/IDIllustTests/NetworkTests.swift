//
//  NetworkTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class NetworkTests: XCTestCase {
    
    private let networkManager = NetworkManager()
    
    func testDataTaskNetworkingWithValidURL() {
        let expectation = XCTestExpectation(description: "DataTaskNetworkingSuccess")
        
        networkManager.getResource(url: URL(string: "http://3.34.77.7/api/entry"),
                                   method: .get,
                                   headers: nil,
                                   handler: { result in
                                    switch result {
                                    case .success(_):
                                        expectation.fulfill()
                                    case .failure(_):
                                        XCTFail()
                                    }
                                   })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDataTaskNetworkingWithEmptyURL() {
        let expectation = XCTestExpectation(description: "DataTaskNetworkingEmptyURL")
        
        networkManager.getResource(url: URL(string: ""),
                                   method: .get,
                                   headers: nil,
                                   handler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        switch error {
                                        case .emptyURL:
                                            expectation.fulfill()
                                        default:
                                            XCTFail()
                                        }
                                    }
                                   })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDataTaskNetworkingWithRequestError() {
        let expectation = XCTestExpectation(description: "DataTaskNetworkingRequestError")
        
        networkManager.getResource(url: URL(string: "www.1Consumption.go.kr"),
                                   method: .get,
                                   headers: nil,
                                   handler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        switch error {
                                        case .requestError:
                                            expectation.fulfill()
                                        default:
                                            XCTFail()
                                        }
                                    }
                                   })
        
        wait(for: [expectation], timeout: 5.0)
    }
}
