//
//  HTTPHeaders.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct HTTPHeaders {
   
    private(set) var list = [String: String]()
    
    mutating func setValue(value: String, field: String) {
        guard list[field] != nil else {
            list.updateValue(value, forKey: field)
            return
        }
        
        list[field] = value
    }
}
