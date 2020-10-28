//
//  CategoriesTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/25.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class CategoriesTests: XCTestCase {
    
    private var category: IDIllust.Category!
    private var categories: Categories!

    override func setUpWithError() throws {
        category = IDIllust.Category(id: 1, name: "test", url: "url")
        categories = Categories(categories: [category])
    }
    
    func testGetCategories() {
        XCTAssertEqual(categories.category(of: 0), category)
        XCTAssertNil(categories.category(of: 1))
    }
    
}

extension IDIllust.Category: Equatable, Encodable {
    public static func == (lhs: IDIllust.Category, rhs: IDIllust.Category) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.url == rhs.url
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
    }
    
    enum CodingKeys : String, CodingKey{
        case id
        case name
        case url
    }
}

extension Categories: Equatable, Encodable {
    public static func == (lhs: Categories, rhs: Categories) -> Bool {
        return lhs.categories == rhs.categories
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categories, forKey: .categories)
    }
    
    enum CodingKeys : String, CodingKey{
        case categories
    }
}
