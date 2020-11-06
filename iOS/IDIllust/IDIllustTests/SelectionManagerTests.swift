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
    private var componentInfo = ComponentInfo()
    private let componentId = 1
    private let colorId = 2
    
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
        componentInfo.componentId = componentId
        currentSelection.componentInfo = componentInfo
        selectionManager.setCurrent(componentId: componentInfo.componentId)
        
        XCTAssertEqual(selectionManager.current, currentSelection)
    }
    
    func testSetCurrentColorId() {
        componentInfo.componentId = componentId
        componentInfo.corlorId = colorId
        
        selectionManager.setCurrent(componentId: componentId)
        selectionManager.setCurrent(colorId: colorId)
        
        XCTAssertEqual(selectionManager.current.componentInfo, componentInfo)
        
        componentInfo.corlorId = 3
        selectionManager.setCurrent(colorId: 3)
        
        XCTAssertEqual(selectionManager.current.componentInfo, componentInfo)
    }
    
    func testSelectionValid() {
        componentInfo.componentId = componentId
        
        selectionManager.setCurrent(categoryId: categoryId, categoryIndex: 0)
        selectionManager.setCurrent(componentId: componentId)
        
        XCTAssertEqual(selectionManager.selection, [categoryId: componentInfo])
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
        selectionManager.setCurrent(colorId: colorId)
        
        componentInfo.componentId = componentId
        componentInfo.corlorId = colorId
        
        XCTAssertEqual(selectionManager.removeCurrentComponent(), componentInfo)
        
        XCTAssertNil(selectionManager.current.componentInfo)
        XCTAssertNil(selectionManager.selection[categoryId])
    }
}
