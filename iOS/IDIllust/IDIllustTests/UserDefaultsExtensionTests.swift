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
    
    func testSaveEncodableObject() {
        UserDefaults.standard.saveEncodableObject(componentInfo, forKey: key)
        XCTAssertEqual(UserDefaults.standard.loadDecodableObject(ComponentInfo.self, forKey: key), componentInfo)
    }
    
    func testInvalidLoadDecoableObject() {
        XCTAssertNil(UserDefaults.standard.loadDecodableObject(ComponentInfo.self, forKey: "invalidKey"))
    }
}
