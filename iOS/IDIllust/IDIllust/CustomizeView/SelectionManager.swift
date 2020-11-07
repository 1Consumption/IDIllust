//
//  SelectionManager.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

final class SelectionManager {
    
    // categoryId: ComponentInfo(componentId, colorId)
    private(set) var selection: [Int: ComponentInfo] = [Int: ComponentInfo]()
    // componentId: colorId
    private(set) var colorSelectionForEachComponent: [Int?: Int?] = [Int?: Int?]()
    private(set) var current: CurrentSelection = CurrentSelection()
    
    func setCurrent(categoryId: Int?, categoryIndex: Int?) {
        current.categoryId = categoryId
        current.categoryIndex = categoryIndex
    }
    
    func setCurrent(componentId: Int?, componentIndexPath: IndexPath? = nil) {
        current.componentInfo = ComponentInfo()
        current.componentInfo?.componentId = componentId
        current.componentInfo?.componentIndexPath = componentIndexPath
        
        setSelection(current: current)
    }
    
    func setCurrent(colorId: Int?) {
        current.componentInfo?.colorId = colorId
        
        setSelection(current: current)
    }
    
    func isSelectedComponent(categoryId: Int, componentId: Int) -> Bool {
        return selection[categoryId]?.componentId == componentId
    }
    
    @discardableResult
    func removeCurrentComponent() -> ComponentInfo? {
        guard let categoryId = current.categoryId else { return nil }
        
        let componentInfo = selection[categoryId]
        
        selection[categoryId] = nil
        current.componentInfo = nil
        
        return componentInfo
    }
    
    private func setSelection(current: CurrentSelection) {
        guard let categoryId = current.categoryId, let componentInfo = current.componentInfo else { return }
        selection[categoryId] = componentInfo
        colorSelectionForEachComponent[componentInfo.componentId] = componentInfo.colorId
    }
}

struct CurrentSelection {
    var categoryIndex: Int?
    var categoryId: Int?
    var componentInfo: ComponentInfo?
}

struct ComponentInfo {
    var componentId: Int?
    var componentIndexPath: IndexPath?
    var colorId: Int?
}
