//
//  ComponentsTest.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class ComponentsTest: XCTestCase {
    
    private var component: Component!
    private var anotherComponent: Component!
    private var components: Components!
    private var anotherComponents: Components!
    private var componentsManger: ComponentsManager!
    
    override func setUp() {
        super.setUp()
        component = Component(id: 1, name: "test", url: "url")
        anotherComponent = Component(id: 2, name: "test2", url: "url2")
        components = Components(components: [component])
        anotherComponents = Components(components: [anotherComponent])
        componentsManger = ComponentsManager([components])
    }
    
    func testComponentsGetComponent() {
        XCTAssertEqual(components.component(of: 0), component)
        XCTAssertNil(components.component(of: 1))
    }
    
    func testComponentsManagerGetComponents() {
        XCTAssertEqual(componentsManger.components(of: 0), components)
        XCTAssertNil(componentsManger.components(of: 1))
    }
    
    func testComponentsManagerGetComponent() {
        XCTAssertEqual(componentsManger.component(of: IndexPath(item: 0, section: 0)), component)
        XCTAssertNil(componentsManger.component(of: IndexPath(item: 0, section: 1)))
        XCTAssertNil(componentsManger.component(of: IndexPath(item: 1, section: 0)))
    }
    
    func testComponentsManagerAppend() {
        componentsManger.append(anotherComponents)
        XCTAssertEqual(2, componentsManger.count)
        XCTAssertEqual(componentsManger.components(of: 1), anotherComponents)
    }
    
    func testComponentsManagerInsert() {
        componentsManger.insert(anotherComponents, at: 1)
        componentsManger.insert(anotherComponents, at: 0)
        XCTAssertEqual(2, componentsManger.count)
        XCTAssertEqual(componentsManger.components(of: 0), anotherComponents)
    }
}
