//
//  Category.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct Categories: Decodable {
    
    let categories: [Category]
    
    func category(of index: Int) -> Category? {
        guard !isExceed(index: index) else { return nil }
        
        return categories[index]
    }
    
    private func isExceed(index: Int) -> Bool {
        return index >= categories.count
    }
}

struct Category: Decodable {
    
    let id: Int
    let name: String
    let url: String
}
