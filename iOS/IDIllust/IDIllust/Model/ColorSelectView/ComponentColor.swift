//
//  ComponentColor.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/28.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct ComponentColors: Decodable {
    
    let colors: [ComponentColor]
    var count: Int {
        return colors.count
    }
    
    func componentColor(of index: Int) -> ComponentColor? {
        guard !isExceed(index: index) else { return nil }
        
        return colors[index]
    }
    
    private func isExceed(index: Int) -> Bool {
        return index >= colors.count
    }
}

struct ComponentColor: Decodable {
    
    let id: Int
    let name: String
    let url: String
}
