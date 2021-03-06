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
        
        let anotherCategory = IDIllust.Category(id: 2, name: "2", url: "test")
        let anotherCategories = Categories(models: [anotherCategory])
        categoryComponentManager.insert(anotherCategories)
        
        XCTAssertEqual(categoryComponentManager.categories, anotherCategories)
    }
    
    func testInsertComponents() {
        let inserted = categoryComponentManager.components(of: category.id)
        XCTAssertEqual(components, inserted)
        
        let anotherCategoryId = 2
        let anotherComponent = Component(id: 2, name: "2", thumbUrl: "test", colors: [Color(id: 3, name: "test", url: "test")])
        let anotherComponents = Components(models: [anotherComponent])
        categoryComponentManager.insert(anotherComponents, by: anotherCategoryId)
        
        XCTAssertEqual(categoryComponentManager.components(of: anotherCategoryId), anotherComponents)
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
    
    func testFirstIndex() {
        XCTAssertEqual(categoryComponentManager.firstIndex(of: category.id), 0)
        XCTAssertNil(categoryComponentManager.firstIndex(of: 9999))
    }
}
