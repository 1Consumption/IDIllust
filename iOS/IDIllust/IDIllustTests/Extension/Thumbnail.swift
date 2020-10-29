//
//  Thumbnail.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import Foundation

extension Thumbnail: Equatable, Encodable {
    public static func == (lhs: Thumbnail, rhs: Thumbnail) -> Bool {
        return lhs.thumbUrl == rhs.thumbUrl
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(thumbUrl, forKey: .thumbUrl)
    }
    
    enum CodingKeys: String, CodingKey {
        case thumbUrl
    }
}
