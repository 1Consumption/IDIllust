//
//  Component.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct Components: Decodable {
    
    let components: [Component]
    
    var count: Int {
        return components.count
    }
    
    func component(of index: Int) -> Component? {
        guard !isExceed(index: index) else { return nil }
        
        return components[index]
    }
    
    private func isExceed(index: Int) -> Bool {
        return index >= components.count
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
