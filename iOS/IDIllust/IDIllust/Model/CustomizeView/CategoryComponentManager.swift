//
//  CategoryComponentManager.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/27.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

final class CategoryComponentManager {
    
    private var componentsOfCategoryId: [CategoryId: Components] = [Int: Components]()
    private(set) var categories: Categories?
    var categoryCount: Int? {
        return categories?.count
    }
    
    func insert(_ categories: Categories) {
        self.categories = categories
        CategoryComponentManagerEvent.categoryChanged.post()
    }
    
    func insert(_ components: Components, by categoryId: Int) {
        componentsOfCategoryId[categoryId] = components
        CategoryComponentManagerEvent.componentsAppended.post()
    }
    
    func category(of index: Int) -> Category? {
        return categories?.model(of: index)
    }
    
    func components(of categoryId: Int) -> Components? {
        return componentsOfCategoryId[categoryId]
    }
    
    func component(with categoryId: Int, for componentIndex: Int) -> Component? {
        return componentsOfCategoryId[categoryId]?.model(of: componentIndex)
    }
    
    func componentsCount(of categoryId: Int) -> Int? {
        return componentsOfCategoryId[categoryId]?.count
    }
    
    func isExistComponents(with categoryId: Int) -> Bool {
        guard componentsOfCategoryId[categoryId] != nil else { return false }
        
        return true
    }
    
    func firstIndex(of id: CategoryId) -> Int? {
        return categories?.firstIndex { $0.id == id }
    }
}

enum CategoryComponentManagerEvent {
    
    case categoryChanged
    case componentsAppended
    
    static let ModelChanged = Notification.Name("modelChanged")
    
    func post() {
        NotificationCenter.default.post(name: CategoryComponentManagerEvent.ModelChanged,
                                        object: self)
    }
}
