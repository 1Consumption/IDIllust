//
//  TextLengthViewModelTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/11/10.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class TextLengthViewModelTests: XCTestCase {
    
    private var textLengthViewModel: Dynamic<Int>!
    private var expectedValue: Int?
    
    override func setUpWithError() throws {
        textLengthViewModel = Dynamic<Int>()
    }
    
    func testBind() {
        textLengthViewModel.bind { [weak self] value in
            XCTAssertEqual(value, self?.expectedValue)
        }
        
        textLengthViewModel.fire()
        
        expectedValue = 5
        
        textLengthViewModel.value = expectedValue
    }
}
