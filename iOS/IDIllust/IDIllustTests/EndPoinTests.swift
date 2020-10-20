//
//  EndPoinTest.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class EndPoinTests: XCTestCase {
    
    func testEntryEndPointValid() {
        let entry = EndPoint(path: .entry)
        XCTAssertEqual(entry.url, URL(string: "http://3.34.77.7/api/entry"))
    }
    
    func testCategorieEndPointValid() {
        let categories = EndPoint(path: .categories)
        XCTAssertEqual(categories.url, URL(string: "http://3.34.77.7/api/categories"))
    }
}
