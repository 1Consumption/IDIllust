//
//  SelectionManager.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

typealias CategoryId = Int
typealias ComponentId = Int
typealias ColorId = Int

final class SelectionManager {
    
    private(set) var selection: [CategoryId: ComponentInfo] = [CategoryId: ComponentInfo]()
    private(set) var colorSelectionForEachComponent: [ComponentId?: ColorId?] = [ComponentId?: ColorId?]()
    private(set) var current: CurrentSelection = CurrentSelection()
    
    func setCurrentCategory(with categoryId: Int?, for categoryIndex: Int?) {
        current.categoryId = categoryId
        current.categoryIndex = categoryIndex
    }
    
    func setCurrentComponentInfo(with componentId: Int?, for componentIndexPath: IndexPath? = nil) {
        current.componentInfo = ComponentInfo()
        current.componentInfo?.componentId = componentId
        current.componentInfo?.componentIndexPath = componentIndexPath
        
        setSelection(with: current)
    }
    
    func setCurrentColor(with colorId: Int?) {
        current.componentInfo?.colorId = colorId
        
        setSelection(with: current)
    }
    
    func isSelectedComponent(with categoryId: Int, and componentId: Int) -> Bool {
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
    
    private func setSelection(with current: CurrentSelection) {
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
