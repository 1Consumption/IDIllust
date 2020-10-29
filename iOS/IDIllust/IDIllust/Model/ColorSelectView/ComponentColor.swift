//
//  ComponentColor.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/28.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct ComponentColors: Decodable, ModelManageable {
    
    typealias Model = ComponentColor
    
    let models: [Model]
    
    enum CodingKeys: String, CodingKey {
        case models = "colors"
    }
}

struct ComponentColor: Decodable {
    
    let id: Int
    let name: String
    let url: String
}
