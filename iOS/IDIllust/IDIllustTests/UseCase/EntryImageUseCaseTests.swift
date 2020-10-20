//
//  EntryImageUseCaseTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class EntryImageUseCaseTests: XCTestCase {
    
    private var mockNetworkManager: NetworkManageable!
    private var model: EntryImage!
    
    private class MockSuccessNetworkManager: NetworkManageable {
        
        private let model: EntryImage!
        
        init(model: EntryImage) {
            self.model = model
        }
        
        func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
            let data = try! JSONEncoder().encode(model)
            handler(.success(data))
            return nil
        }
    }
    
    private class MockDecodeFailureNetworkManager: NetworkManageable {
        
        struct MockModel: Codable {
            let fake: String
        }
        
        func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
            let model = MockModel(fake: "fake")
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
    
    override func setUp() {
        super.setUp()
        model = EntryImage(url: "testURL")
    }
    
    func testSuccess() {
        EntryImageUseCase().retrieveEntryImageInfo(networkManager: MockSuccessNetworkManager(model: model), successHandler: { received in
            XCTAssertEqual(received, self.model)
        })
    }
    
    func testSuccessWithNotEquealResult() {
        EntryImageUseCase().retrieveEntryImageInfo(networkManager: MockSuccessNetworkManager(model: model), successHandler: { received in
            XCTAssertNotEqual(received, EntryImage(url: ""))
        })
    }
    
    func testNetworkFailure() {
        EntryImageUseCase().retrieveEntryImageInfo(networkManager: MockNetworkFailureNetworkManager(),
                                                   failureHandler: { error in
                                                    XCTAssertEqual(error, .networkError(.dataEmpty))
                                                   },
                                                   successHandler: { _ in
                                                    XCTFail()
                                                   })
    }
    
    func testDecodeFailure() {
        EntryImageUseCase().retrieveEntryImageInfo(networkManager: MockDecodeFailureNetworkManager(),
                                                   failureHandler: { error in
                                                    XCTAssertEqual(error, .decodeError)
                                                   },
                                                   successHandler: { _ in
                                                    XCTFail()
                                                   })
    }
}

extension UseCaseError: Equatable {
    public static func == (lhs: UseCaseError, rhs: UseCaseError) -> Bool {
        switch (lhs, rhs) {
        case (.decodeError, .decodeError), (.networkError, .networkError):
            return true
            
        default:
            return false
        }
    }
}
