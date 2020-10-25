//
//  EndPoint.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct EndPoint {
    
    init(path: Path) {
        self.path = path
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path.description
        
        return components.url
    }
    
    private let scheme = "http"
    private let host = "3.34.77.7"
    private let path: Path
    
    enum Path {
        case entry
        case categories
        case components(Int)
        
        var description: String {
            switch self {
            case .entry:
                return "/api/entry"
            case .categories:
                return "/api/categories"
            case .components(let categoryId):
                return "/api/categories/\(categoryId)/components"
            }
        }
    }
}
