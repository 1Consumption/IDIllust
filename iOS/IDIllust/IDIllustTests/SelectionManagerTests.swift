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
    
    override func setUpWithError() throws {
        selectionManager = SelectionManager()
        currentSelection = CurrentSelection()
    }
    
    func testSetCurrentCategoryIdCategoryIndex() {
        currentSelection.categoryId = 0
        currentSelection.categoryIndex = 0
        
        selectionManager.setCurrent(categoryId: 0, categoryIndex: 0)
        
        XCTAssertEqual(selectionManager.current, currentSelection)
    }
    
    func testSetCurrentComponentId() {
        currentSelection.componentId = 1
        
        selectionManager.setCurrent(componentId: 1)
        
        XCTAssertEqual(selectionManager.current, currentSelection)
    }
    
    func testSelectionValid() {
        selectionManager.setCurrent(categoryId: 1, categoryIndex: 0)
        selectionManager.setCurrent(componentId: 2)
        
        XCTAssertEqual(selectionManager.selection, [1: 2])
    }
}
