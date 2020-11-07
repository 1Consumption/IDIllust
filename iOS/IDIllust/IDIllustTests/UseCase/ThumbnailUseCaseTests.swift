//
//  ThumbnailUseCaseTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

class ThumbnailUseCaseTests: XCTestCase {

    private var mockNetworkManager: NetworkManageable!
    private var model: Thumbnail!

    override func setUpWithError() throws {
        model = Thumbnail(thumbUrl: "test")
    }
    
    func testSuccess() {
        mockNetworkManager = MockSuccessNetworkManager(model: model)
        let componentInfo = ComponentInfo(componentId: 0, componentIndexPath: IndexPath(item: 0, section: 0), colorId: 3)
        let currentSelection = CurrentSelection(categoryIndex: 1, categoryId: 2, componentInfo: componentInfo)
        ThumbnailUseCase().retrieveThumbnail(currentSelection, 
                                             networkManager: mockNetworkManager,
                                             successHandler: { model in
                                                XCTAssertEqual(model, self.model)
                                             })
    }
    
    func testNetworkError() {
        let currentSelection = CurrentSelection()
        mockNetworkManager = MockSuccessNetworkManager(model: model)
        ThumbnailUseCase().retrieveThumbnail(currentSelection,
                                             networkManager: mockNetworkManager,
                                             failurehandler: { error in
                                                XCTAssertEqual(error, UseCaseError.networkError(.requestError))
                                             },
                                             successHandler: { _ in })
    }
}
