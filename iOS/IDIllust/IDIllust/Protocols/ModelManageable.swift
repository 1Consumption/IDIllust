//
//  ModelManageable.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/28.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

protocol ModelManageable {
    
    associatedtype Model
    
    var models: [Model] { get }
    var count: Int { get }
    func model(of index: Int) -> Model?
    func isExceed(index: Int) -> Bool
}

extension ModelManageable {
    var count: Int {
        return models.count
    }
    
    func model(of index: Int) -> Model? {
        guard !isExceed(index: index) else { return nil }
        
        return models[index]
    }
    
    func isExceed(index: Int) -> Bool {
        return index >= models.count
    }
}
