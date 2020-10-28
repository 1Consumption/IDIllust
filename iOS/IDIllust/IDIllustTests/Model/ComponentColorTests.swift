//
//  ComponentColorTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/28.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class ComponentColorTests: XCTestCase {

    private var componentColors: ComponentColors!
    private var componentColor: ComponentColor!
    
    override func setUpWithError() throws {
        componentColor = ComponentColor(id: 1, name: "color", url: "test")
        componentColors = ComponentColors(colors: [componentColor])
    }
    
    func testComponentColorsCount() {
        XCTAssertEqual(componentColors.count, 1)
    }
    
    func testComponentColorsGetComponentColor() {
        XCTAssertEqual(componentColors.componentColor(of: 0), componentColor)
        XCTAssertNil(componentColors.componentColor(of: 1))
    }
}

extension ComponentColor: Equatable {
    public static func == (lhs: ComponentColor, rhs: ComponentColor) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.url == rhs.url
    }
}
