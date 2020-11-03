//
//  SelectionManager.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

final class SelectionManager {
    
    // categoryId: ComponentId
    private(set) var selection: [Int: Int] = [Int: Int]()
    private(set) var current: CurrentSelection = CurrentSelection()
    
    func setCurrent(categoryId: Int?, categoryIndex: Int?) {
        current.categoryId = categoryId
        current.categoryIndex = categoryIndex
    }
    
    func setCurrent(componentId: Int?) {
        current.componentId = componentId
        
        setSelection(current: current)
    }
    
    func isSelectedComponent(categoryId: Int, componentId: Int) -> Bool {
        return selection[categoryId] == componentId
    }
    
    @discardableResult
    func removeCurrentComponent() -> Int? {
        guard let categoryId = current.categoryId else { return nil }
        
        let componentId = selection[categoryId]
        selection[categoryId] = nil
        current.componentId = nil
        
        return componentId
    }
    
    private func setSelection(current: CurrentSelection) {
        guard let categoryId = current.categoryId, let componentId = current.componentId else { return }
        selection[categoryId] = componentId
    }
}

final class CurrentSelection {
    var categoryIndex: Int?
    var categoryId: Int?
    var componentId: Int?
}
