//
//  Category.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct Categories: Codable, Equatable {
    
    let categories: [Category]
    
    func category(of index: Int) -> Category? {
        if index > categories.count {
            return nil
        }
        
        return categories[index]
    }
}

struct Category: Codable, Equatable {
    
    let id: Int
    let name: String
    let url: String
}
