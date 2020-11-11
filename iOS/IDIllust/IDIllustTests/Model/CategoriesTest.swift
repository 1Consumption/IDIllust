//
//  CategoriesTest.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/11/11.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class CategoriesTest: XCTestCase {
    
    private var category: IDIllust.Category!
    private var categories: Categories!

    override func setUpWithError() throws {
        category = IDIllust.Category(id: 1, name: "test", url: "url")
        categories = Categories(models: [category])
    }
    
    func testFirstIndex() {
        XCTAssertEqual(categories.firstIndex{ $0.id == category.id }, 0)
        XCTAssertNil(categories.firstIndex{ $0.id == 999 })
    }
}
