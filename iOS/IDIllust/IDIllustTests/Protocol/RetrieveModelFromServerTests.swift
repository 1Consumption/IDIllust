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
