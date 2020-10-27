//
//  ComponentsTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class ComponentsTests: XCTestCase {
    
    private var component: Component!
    private var components: Components!
    
    override func setUp() {
        super.setUp()
        component = Component(id: 1, name: "test", url: "url")
        components = Components(components: [component])
    }
    
    func testComponentsGetComponent() {
        XCTAssertEqual(components.component(of: 0), component)
        XCTAssertNil(components.component(of: 1))
    }
    
    func testCount() {
        XCTAssertEqual(components.count, 1)
    }
}

extension Component: Equatable, Encodable {
    public static func == (lhs: Component, rhs: Component) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.url == rhs.url
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
    }
}

extension Components: Equatable, Encodable {
    public static func == (lhs: Components, rhs: Components) -> Bool {
        return lhs.components == rhs.components
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(components, forKey: .components)
    }
    
    enum CodingKeys : String, CodingKey{
        case components
    }
}
