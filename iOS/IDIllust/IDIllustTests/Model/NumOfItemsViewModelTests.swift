//
//  NumOfItemsViewModelTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/11/18.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class NumOfItemsViewModelTests: XCTestCase {

    private var numOfItemsViewModel: NumOfItemsViewModel!
    private var result: Bool?
    
    override func setUpWithError() throws {
        numOfItemsViewModel = NumOfItemsViewModel()
    }
    
    func testBindCurrentPage() {
        numOfItemsViewModel.setHasItems(count: 5)
        XCTAssertNil(result)
        
        numOfItemsViewModel.bindHasItems { [weak self] hasItems in
            guard let hasItems = hasItems else { return }
            self?.result = hasItems
        }
        
        numOfItemsViewModel.setHasItems(count: 5)
        XCTAssertTrue(result!)
        
        numOfItemsViewModel.setHasItems(count: 0)
        XCTAssertFalse(result!)
    }

    func testFireCurrentPage() {
        numOfItemsViewModel.setHasItems(count: 5)
        numOfItemsViewModel.bindHasItems(handler: { [weak self] hasItems in
            self?.result = hasItems
        })
        XCTAssertNil(result)

        numOfItemsViewModel.fireHasItems()
        XCTAssertTrue(result!)
    }
}
