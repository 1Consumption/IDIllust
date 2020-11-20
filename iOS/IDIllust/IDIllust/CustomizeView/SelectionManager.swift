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
typealias ComponentSelectionForCategryId = [CategoryId: ComponentInfo]
typealias ColorSelectionForComponentId = [ComponentId?: ColorId?]

final class SelectionManager {
    
    static private let selectionKey: String = "selectionKey"
    static private let colorSelectionKey: String = "colorSelectionKey"
    static private let currentKey: String = "currentKey"
    private(set) var selection: ComponentSelectionForCategryId
    private(set) var colorSelectionForEachComponent: ColorSelectionForComponentId
    private(set) var current: CurrentSelection
    
    init(wholeSelection: ComponentSelectionForCategryId, colorSelection: ColorSelectionForComponentId, currentSelection: CurrentSelection) {
        selection = wholeSelection
        colorSelectionForEachComponent = colorSelection
        current = currentSelection
    }
    
    convenience init() {
        self.init(wholeSelection: ComponentSelectionForCategryId(), colorSelection: ColorSelectionForComponentId(), currentSelection: CurrentSelection())
    }
    
    convenience init?(userDefaults: UserDefaults) {
        guard let wholeSelection = userDefaults.loadDecodableObject(ComponentSelectionForCategryId.self, forKey: SelectionManager.selectionKey),
              let colorSelection = userDefaults.loadDecodableObject(ColorSelectionForComponentId.self, forKey: SelectionManager.colorSelectionKey),
              let currentSelection = userDefaults.loadDecodableObject(CurrentSelection.self, forKey: SelectionManager.currentKey) else { return nil }
        
        self.init(wholeSelection: wholeSelection, colorSelection: colorSelection, currentSelection: currentSelection)
    }
    
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
    
    func setSelection(with categoryId: Int, for url: String) {
        var componetInfo = selection[categoryId]
        componetInfo?.thumbnailUrl = url
        selection[categoryId] = componetInfo
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
    
    func resetAll() {
        selection = [:]
        colorSelectionForEachComponent = [:]
        current.componentInfo = nil
    }
    
    func saveCurrentSelection(to userDefaults: UserDefaults) {
        userDefaults.saveEncodableObject(colorSelectionForEachComponent, forKey: SelectionManager.colorSelectionKey)
        userDefaults.saveEncodableObject(current, forKey: SelectionManager.currentKey)
        userDefaults.saveEncodableObject(selection, forKey: SelectionManager.selectionKey)
    }
    
    func removeCurrentSelection(from userDefaults: UserDefaults) {
        userDefaults.removeObject(forKey: SelectionManager.colorSelectionKey)
        userDefaults.removeObject(forKey: SelectionManager.currentKey)
        userDefaults.removeObject(forKey: SelectionManager.selectionKey)
    }
    
    private func setSelection(with current: CurrentSelection) {
        guard let categoryId = current.categoryId, let componentInfo = current.componentInfo else { return }
        selection[categoryId] = componentInfo
        colorSelectionForEachComponent[componentInfo.componentId] = componentInfo.colorId
    }
}

struct CurrentSelection: Codable {
    var categoryIndex: Int?
    var categoryId: Int?
    var componentInfo: ComponentInfo?
}

struct ComponentInfo: Codable {
    var componentId: Int?
    var componentIndexPath: IndexPath?
    var colorId: Int?
    var thumbnailUrl: String?
}
