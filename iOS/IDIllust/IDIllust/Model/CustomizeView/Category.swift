//
//  Category.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct Categories: Decodable, ModelManageable {
    
    typealias Model = Category
    
    let models: [Model]
    
    enum CodingKeys: String, CodingKey {
        case models = "categories"
    }
}

struct Category: Decodable {
    
    let id: Int
    let name: String
    let url: String
}
