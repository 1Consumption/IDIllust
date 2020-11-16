//
//  TutorialViewModelTest.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/11/16.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class TutorialViewModelTest: XCTestCase {

    private var tutorialViewModel: TutorialViewModel!
    private var result: Int?
    
    override func setUpWithError() throws {
        tutorialViewModel = TutorialViewModel()
    }
    
    func testBindCurrentPage() {
        tutorialViewModel.setPage(5)
        XCTAssertNil(result)
        
        tutorialViewModel.bindCurrentPage { [weak self] page in
            guard let page = page else { return }
            self?.result = -page
        }
        
        tutorialViewModel.setPage(5)
        XCTAssertEqual(-5, result)
    }

    func testFireCurrentPage() {
        tutorialViewModel.setPage(5)
        tutorialViewModel.bindCurrentPage(handler: { [weak self] page in
            self?.result = page
        })
        XCTAssertNil(result)
        
        tutorialViewModel.fireCurrentPage()
        XCTAssertEqual(result, 5)
    }
}
