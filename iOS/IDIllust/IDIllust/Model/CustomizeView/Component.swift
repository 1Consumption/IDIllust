//
//  Component.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

final class ComponentsManager {
    
    private var componentsList: [Components]
    var count: Int {
        return componentsList.count
    }
    
    init(_ components: [Components] = [Components]()) {
        self.componentsList = components
    }
    
    func append(_ components: Components) {
        componentsList.append(components)
    }
    
    func insert(_ components: Components, at index: Int) {
        guard !isExceed(index: index) else { return }
        
        componentsList.insert(components, at: index)
    }
    
    func components(of index: Int) -> Components? {
        guard !isExceed(index: index) else { return nil }
        
        return componentsList[index]
    }
    
    func component(of indexPath: IndexPath) -> Component? {
        guard !isExceed(indexPath: indexPath) else { return nil }
        
        return componentsList[indexPath.section].component(of: indexPath.item)
    }
    
    private func isExceed(index: Int) -> Bool {
        guard index < componentsList.count else { return true }
        
        return false
    }
    
    private func isExceed(indexPath: IndexPath) -> Bool {
        guard !isExceed(index: indexPath.section) else { return true }
        guard componentsList[indexPath.section].component(of: indexPath.item) != nil else { return true }
        
        return false
    }
}

struct Components: Codable, Equatable {
    
    let components: [Component]
    
    func component(of index: Int) -> Component? {
        guard !isExceed(index: index) else { return nil }
        
        return components[index]
    }
    
    private func isExceed(index: Int) -> Bool {
        return index >= components.count
    }
}

struct Component: Codable, Equatable {
    
    let id: Int
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url = "thumb_url"
    }
}
