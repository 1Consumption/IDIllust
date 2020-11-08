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
    private var colors: [Color]!

    override func setUpWithError() throws {
        categoryComponentManager = CategoryComponentManager()
        category = IDIllust.Category(id: 1, name: "category", url: "url")
        categories = Categories(models: [category])
        colors = [Color(id: 1, name: "color", url: "url")]
        component = Component(id: 1, name: "component", thumbUrl: "url", colors: colors)
        components = Components(models: [component])
        
        categoryComponentManager.insert(categories)
        categoryComponentManager.insert(components, by: category.id)
    }
    
    func testInsertCategories() {
        let inserted = categoryComponentManager.categories
        XCTAssertEqual(categories, inserted)
    }
    
    func testInsertComponents() {
        let inserted = categoryComponentManager.components(of: category.id)
        XCTAssertEqual(components, inserted)
    }
    
    func testCategory() {
        let inserted = categoryComponentManager.category(of: 0)
        XCTAssertEqual(category, inserted)
    }
    
    func testCategoryCount() {
        XCTAssertEqual(categoryComponentManager.categoryCount, 1)
    }
    
    func testComponentsCount() {
        XCTAssertEqual(categoryComponentManager.componentsCount(of: category.id), 1)
    }
    
    func testGetComponent() {
        XCTAssertEqual(categoryComponentManager.component(with: category.id, for: 0), component)
    }
    
    func testIsExistComponents() {
        XCTAssertTrue(categoryComponentManager.isExistComponents(with: category.id))
        XCTAssertFalse(categoryComponentManager.isExistComponents(with: -1))
    }
}
