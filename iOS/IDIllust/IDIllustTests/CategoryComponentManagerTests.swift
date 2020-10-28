//
//  CategoryComponentManagerTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/27.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class CategoryComponentManagerTests: XCTestCase {
    
    private var categoryComponentManager: CategoryComponentManager!
    private var category: IDIllust.Category!
    private var categories: Categories!
    private var component: Component!
    private var components: Components!

    override func setUpWithError() throws {
        categoryComponentManager = CategoryComponentManager()
        category = IDIllust.Category(id: 1, name: "category", url: "url")
        categories = Categories(models: [category])
        component = Component(id: 1, name: "component", url: "url")
        components = Components(models: [component])
    }
    
    func testInsertCategories() {
        categoryComponentManager.insert(categories: categories)
        let inserted = categoryComponentManager.categories
        XCTAssertEqual(categories, inserted)
    }
    
    func testInsertComponents() {
        categoryComponentManager.insert(categories: categories)
        categoryComponentManager.insert(components: components, by: category.id)
        let inserted = categoryComponentManager.components(of: category.id)
        XCTAssertEqual(components, inserted)
    }
    
    func testCategory() {
        categoryComponentManager.insert(categories: categories)
        let inserted = categoryComponentManager.category(of: 0)
        XCTAssertEqual(category, inserted)
    }
    
    func testCategoryCount() {
        XCTAssertNil(categoryComponentManager.categoryCount)
        categoryComponentManager.insert(categories: categories)
        XCTAssertEqual(categoryComponentManager.categoryCount, 1)
    }
    
    func testComponentsCount() {
        XCTAssertNil(categoryComponentManager.componentsCount(of: category.id))
        categoryComponentManager.insert(categories: categories)
        categoryComponentManager.insert(components: components, by: category.id)
        XCTAssertEqual(categoryComponentManager.componentsCount(of: category.id), 1)
    }
    
    func testIsExistComponents() {
        categoryComponentManager.insert(categories: categories)
        categoryComponentManager.insert(components: components, by: category.id)
        XCTAssertTrue(categoryComponentManager.isExistComponents(with: category.id))
        XCTAssertFalse(categoryComponentManager.isExistComponents(with: -1))
    }
}
