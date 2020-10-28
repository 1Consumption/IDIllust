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
    private var model: Categories!
    
    override func setUp() {
        super.setUp()
        let category = IDIllust.Category(id: 1, name: "test", url: "url")
        model = Categories(models: [category])
    }

    func testSuccess() {
        mockNetworkManager = MockSuccessNetworkManager(model: model)
        
        CategoriesUseCase().retrieveCategories(networkManager: mockNetworkManager,
                                                    successHandler: { model in
                                                        XCTAssertEqual(self.model, model)
                                                    })
    }
}
