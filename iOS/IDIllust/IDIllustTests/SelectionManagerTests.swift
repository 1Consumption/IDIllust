//
//  SelectionManagerTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class SelectionManagerTests: XCTestCase {
    
    private var selectionManager: SelectionManager!
    private var currentSelection: CurrentSelection!
    private let categoryId = 0
    private let componentId = 1
    
    override func setUpWithError() throws {
        selectionManager = SelectionManager()
        currentSelection = CurrentSelection()
    }
    
    func testSetCurrentCategoryIdCategoryIndex() {
        currentSelection.categoryId = categoryId
        currentSelection.categoryIndex = 0
        selectionManager.setCurrent(categoryId: categoryId, categoryIndex: 0)
        
        XCTAssertEqual(selectionManager.current, currentSelection)
    }
    
    func testSetCurrentComponentId() {
        currentSelection.componentId = componentId
        selectionManager.setCurrent(componentId: componentId)
        
        XCTAssertEqual(selectionManager.current, currentSelection)
    }
    
    func testSelectionValid() {
        selectionManager.setCurrent(categoryId: categoryId, categoryIndex: 0)
        selectionManager.setCurrent(componentId: componentId)
        
        XCTAssertEqual(selectionManager.selection, [categoryId: componentId])
    }
    
    func testIsSelectedComponent() {
        selectionManager.setCurrent(categoryId: categoryId, categoryIndex: 0)
        selectionManager.setCurrent(componentId: componentId)
        
        XCTAssertTrue(selectionManager.isSelectedComponent(categoryId: categoryId, componentId: componentId))
        XCTAssertFalse(selectionManager.isSelectedComponent(categoryId: categoryId, componentId: 9))
    }
    
    func testRemoveCurrentComponent() {
        XCTAssertNil(selectionManager.removeCurrentComponent())
        
        selectionManager.setCurrent(categoryId: categoryId, categoryIndex: 0)
        selectionManager.setCurrent(componentId: componentId)
        
        XCTAssertEqual(selectionManager.removeCurrentComponent(), componentId)
        
        XCTAssertNil(selectionManager.current.componentId)
        XCTAssertNil(selectionManager.selection[categoryId])
    }
}
