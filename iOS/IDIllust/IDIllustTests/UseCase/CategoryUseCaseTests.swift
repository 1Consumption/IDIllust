//
//  CategoryUseCaseTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class CategoryUseCaseTests: XCTestCase {
    
    private var mockNetworkManager: NetworkManageable!
    private var model: [IDIllust.Category]!
    
    private class MockSuccessNetworkManager: NetworkManageable {
        
        private let model: Categories!
        
        init(model: Categories) {
            self.model = model
        }
        
        func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
            let data = try! JSONEncoder().encode(model)
            handler(.success(data))
            return nil
        }
    }
    
    override func setUp() {
        super.setUp()
        model = [Category(id: 1, name: "category", url: "test")]
    }
    
    func testSuccess() {
        mockNetworkManager = MockSuccessNetworkManager(model: Categories(categories: model))
        
        CategoriesUseCase().retrieveCategories(networkManager: mockNetworkManager,
                                                    successHandler: { model in
                                                        XCTAssertEqual(self.model, model)
                                                    })
    }
    
    func testSuccessWithNotEquealResult() {
        mockNetworkManager = MockSuccessNetworkManager(model: Categories(categories: model))
        
        CategoriesUseCase().retrieveCategories(networkManager: mockNetworkManager, successHandler: { received in
            XCTAssertNotEqual(received, [Category(id: 1, name: "not equal", url: "test")])
        })
    }
}
