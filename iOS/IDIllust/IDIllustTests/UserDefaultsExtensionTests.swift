//
//  UserDefaultsExtensionTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/11/15.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class UserDefaultsExtensionTests: XCTestCase {
    
    private var componentInfo: ComponentInfo!
    private var key: String!
    
    override func setUpWithError() throws {
        componentInfo = ComponentInfo(componentId: 1, componentIndexPath: IndexPath(item: 1, section: 1), colorId: 2, thumbnailUrl: "url")
        key = "KEY"
    }
    
    func testSaveSelection() {
        UserDefaults.standard.saveSelection(componentInfo, forKey: key)
        XCTAssertEqual(UserDefaults.standard.loadSelection(ComponentInfo.self, forKey: key), componentInfo)
    }
    
    func testInvalidLoadSelection() {
        XCTAssertNil(UserDefaults.standard.loadSelection(ComponentInfo.self, forKey: "invalidKey"))
    }
    
    func testRemoveSelection() {
        UserDefaults.standard.saveSelection(componentInfo, forKey: key)
        UserDefaults.standard.removeSelection(forKey: key)
        XCTAssertNil(UserDefaults.standard.loadSelection(ComponentInfo.self, forKey: key))
    }
}
