//
//  Components.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust

extension Component: Equatable, Encodable {
    public static func == (lhs: Component, rhs: Component) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.thumbUrl == rhs.thumbUrl
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(thumbUrl, forKey: .thumbUrl)
    }
    
    enum CodingKeys : String, CodingKey{
        case id
        case name
        case thumbUrl
    }
}

extension Components: Equatable, Encodable {
    public static func == (lhs: Components, rhs: Components) -> Bool {
        return lhs.models == rhs.models
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(models, forKey: .models)
    }
}
