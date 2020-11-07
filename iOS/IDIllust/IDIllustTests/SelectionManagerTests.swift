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
    private let componentIndexPath = IndexPath(item: 0, section: 0)
    private let colorId = 2
    
    override func setUpWithError() throws {
        selectionManager = SelectionManager()
        currentSelection = CurrentSelection()
        
        componentInfo.componentId = componentId
        componentInfo.colorId = colorId
        
        currentSelection.categoryId = categoryId
        currentSelection.categoryIndex = 0
        currentSelection.componentInfo = componentInfo
        
        selectionManager.setCurrent(categoryId: categoryId, categoryIndex: 0)
        selectionManager.setCurrent(componentId: componentInfo.componentId)
        selectionManager.setCurrent(colorId: componentInfo.colorId)
    }
    
    func testSetCurrentCategoryIdCategoryIndex() {
        XCTAssertEqual(selectionManager.current, currentSelection)
    }
    
    func testSetCurrentComponentId() {
        XCTAssertEqual(selectionManager.current, currentSelection)
        
        selectionManager.removeCurrentComponent()
        componentInfo.colorId = nil
        
        componentInfo.componentId = componentId
        componentInfo.componentIndexPath = componentIndexPath
        currentSelection.componentInfo = componentInfo
        selectionManager.setCurrent(componentId: componentId, componentIndexPath: componentIndexPath)
        
        XCTAssertEqual(selectionManager.current, currentSelection)
    }
    
    func testSetCurrentColorId() {
        XCTAssertEqual(selectionManager.colorSelectionForEachComponent[componentId], colorId)
        XCTAssertEqual(selectionManager.current.componentInfo, componentInfo)
        
        componentInfo.colorId = 3
        selectionManager.setCurrent(colorId: 3)
        
        XCTAssertEqual(selectionManager.current.componentInfo, componentInfo)
    }
    
    func testSelectionValid() {
        XCTAssertEqual(selectionManager.selection, [categoryId: componentInfo])
    }
    
    func testIsSelectedComponent() {
        XCTAssertTrue(selectionManager.isSelectedComponent(categoryId: categoryId, componentId: componentId))
        XCTAssertFalse(selectionManager.isSelectedComponent(categoryId: categoryId, componentId: 9))
    }
    
    func testRemoveCurrentComponent() {
        XCTAssertEqual(selectionManager.removeCurrentComponent(), componentInfo)
        
        selectionManager.setCurrent(categoryId: categoryId, categoryIndex: 0)
        selectionManager.setCurrent(componentId: componentId)
        selectionManager.setCurrent(colorId: colorId)
        
        componentInfo.componentId = componentId
        componentInfo.colorId = colorId
        
        XCTAssertEqual(selectionManager.removeCurrentComponent(), componentInfo)
        
        XCTAssertNil(selectionManager.current.componentInfo)
        XCTAssertNil(selectionManager.selection[categoryId])
    }
}
