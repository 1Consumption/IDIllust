//
//  ComponentsUseCaseTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/24.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class ComponentsUseCaseTests: XCTestCase {
    
    private var mockNetworkManager: NetworkManageable!
    private var model: Components!

    override func setUpWithError() throws {
        let component = IDIllust.Component(id: 1, name: "test", thumbUrl: "url", colors: [Color(id: 1, name: "test", url: "url")])
        model = Components(models: [component])
    }
    
    func testSuccess() {
        mockNetworkManager = MockSuccessNetworkManager(model: model)
        
        ComponentsUseCase().retrieveComponents(networkManager: mockNetworkManager,
                                               categoryId: 0,
                                               successHandler: { model in
                                                XCTAssertEqual(self.model, model)
                                               })
    }
}
