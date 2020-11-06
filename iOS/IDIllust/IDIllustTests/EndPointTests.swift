//
//  EndPointTest.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class EndPointTests: XCTestCase {
    
    func testEntryEndPointValid() {
        let entry = EndPoint(path: .entry)
        XCTAssertEqual(entry.url, URL(string: "http://3.34.77.7/api/entry"))
    }
    
    func testCategorieEndPointValid() {
        let categories = EndPoint(path: .categories)
        XCTAssertEqual(categories.url, URL(string: "http://3.34.77.7/api/categories"))
    }
    
    func testComponentsEndPointValid() {
        let components = EndPoint(path: .components(categoryId: 1))
        XCTAssertEqual(components.url, URL(string: "http://3.34.77.7/api/categories/1/components"))
    }
    
    func testThumbnailEndPointValid() {
        let thumbnail = EndPoint(path: .thumbnail(categoryId: 1, componentId: 1))
        XCTAssertEqual(thumbnail.url, URL(string: "http://3.34.77.7/api/categories/1/components/1"))
        
        let thumbnailWithColorId = EndPoint(path: .thumbnail(categoryId: 1, componentId: 1, colorId: 2))
        XCTAssertEqual(thumbnailWithColorId.url, URL(string: "http://3.34.77.7/api/categories/1/components/1/colors/2"))
    }
}
