//
//  ModelManageableTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/28.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class ModelManageableTests: XCTestCase {
    
    private var mockModels: MockModels!
    private var mockModel: MockModel!
    
    struct MockModels: ModelManageable, Equatable {
        static func == (lhs: MockModels, rhs: MockModels) -> Bool {
            return lhs.models == rhs.models
        }
        
        typealias Model = MockModel
        let models: [MockModel]
    }
    
    struct MockModel: Decodable, Equatable {
        let id: Int
    }

    override func setUpWithError() throws {
        mockModel = MockModel(id: 1)
        mockModels = MockModels(models: [mockModel])
    }
    
    func testMockModelsCount() {
        XCTAssertEqual(mockModels.count, 1)
    }
    
    func testMockModelsGetModel() {
        XCTAssertEqual(mockModels.model(of: 0), mockModel)
        XCTAssertNil(mockModels.model(of: 1))
        XCTAssertEqual(mockModels, mockModels)
    }
}
