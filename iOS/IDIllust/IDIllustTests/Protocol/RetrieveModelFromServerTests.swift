//
//  RetrieveModelFromServerTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/23.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class RetrieveModelFromServerTests: XCTestCase {
    
    private var mockModel: MockModel!
    private var mockNetworkManager: NetworkManageable!
    
    private struct MockModel: Codable, Equatable {
        let id: Int
    }
    
    private struct MockUseCase<T>: RetrieveModelFromServer where T: Codable {
        typealias Model = T
    }
    
    private class MockSuccessNetworkManager<T>: NetworkManageable where T: Codable {
        
        private let model: T!
        
        init(model: T) {
            self.model = model
        }
        
        func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
            let data = try! JSONEncoder().encode(model)
            handler(.success(data))
            return nil
        }
    }
    
    private class MockDecodeFailureNetworkManager: NetworkManageable {
        
        struct DecodeErrorModel: Codable {
            let fake: String
        }
        
        func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
            let model = DecodeErrorModel(fake: "fake")
            let data = try! JSONEncoder().encode(model)
            handler(.success(data))
            return nil
        }
    }
    
    private class MockNetworkFailureNetworkManager: NetworkManageable {
        
        func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
            handler(.failure(.requestError))
            return nil
        }
    }
    
    override func setUpWithError() throws {
        mockModel = MockModel(id: 1)
    }
    
    func testSuccess() {
        mockNetworkManager = MockSuccessNetworkManager(model: mockModel)
        
        MockUseCase().retrieveModel(from: .init(path: .entry),
                                    networkManager: mockNetworkManager,
                                    failurehandler: { _ in
                                        XCTFail()
                                    },
                                    successHandler: { model in
                                        XCTAssertEqual(self.mockModel, model)
                                    })
    }
    
    func testDecodeError() {
        mockNetworkManager = MockDecodeFailureNetworkManager()
        
        MockUseCase<MockModel>().retrieveModel(from: .init(path: .entry),
                                               networkManager: mockNetworkManager,
                                               failurehandler: { error in
                                                XCTAssertEqual(error, .decodeError)
                                               }, successHandler: { _ in
                                                XCTFail()
                                               })
    }
    
    func testNetworkError() {
        mockNetworkManager = MockNetworkFailureNetworkManager()
        
        MockUseCase<MockModel>().retrieveModel(from: .init(path: .entry),
                                               networkManager: mockNetworkManager,
                                               failurehandler: { error in
                                                XCTAssertEqual(error, .networkError(.dataEmpty))
                                               },
                                               successHandler: { _ in
                                                XCTFail()
                                               })
    }
}
