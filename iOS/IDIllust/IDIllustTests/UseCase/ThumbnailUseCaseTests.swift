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
        
        ThumbnailUseCase().retrieveThumbnail(0, 0,
                                             networkManager: mockNetworkManager,
                                             successHandler: { model in
                                                XCTAssertEqual(model, self.model)
                                             })
    }
}
