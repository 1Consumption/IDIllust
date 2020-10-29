//
//  Component.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct Components: Decodable, ModelManageable {
    
    typealias Model = Component
    
    let models: [Model]
    
    enum CodingKeys: String, CodingKey {
        case models = "components"
    }
}

struct Component: Decodable {
    
    let id: Int
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url = "thumb_url"
    }
}
