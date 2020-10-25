//
//  EntryImageUseCaseTests.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import XCTest

final class EntryImageUseCaseTests: XCTestCase {
    
    private var mockNetworkManager: NetworkManageable!
    private var model: EntryImage!

    override func setUp() {
        super.setUp()
        model = EntryImage(url: "testURL")
    }
    
    func testSuccess() {
        EntryImageUseCase().retrieveEntryImageInfo(networkManager: MockSuccessNetworkManager(model: model), successHandler: { received in
            XCTAssertEqual(received, self.model)
        })
    }
}

extension EntryImage: Equatable, Encodable {
    public static func == (lhs: EntryImage, rhs: EntryImage) -> Bool {
        return lhs.url == rhs.url
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
    }
    
    enum CodingKeys : String, CodingKey{
        case url
    }
}
