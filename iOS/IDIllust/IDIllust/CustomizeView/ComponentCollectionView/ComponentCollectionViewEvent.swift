//
//  ComponentCollectionViewEvent.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

enum ComponentCollectionViewEvent {
    
    case longPressBegan(currentPoint: CGPoint, selectedIndexPath: IndexPath)
    case longPressEnded
    case longPressChanged(currentXPoint: CGFloat)
    case didSelect(selectedIndexPath: IndexPath)
    
    static let LongPressGestureStateChanged = Notification.Name("longPressGestureStateChanged")
    static let DidSelect = Notification.Name("didSelect")
    
    func post() {
        switch self {
        case .longPressBegan(_, _), .longPressChanged(_), .longPressEnded:
            NotificationCenter.default.post(name: ComponentCollectionViewEvent.LongPressGestureStateChanged,
                                            object: self)
        
        case .didSelect(_):
            NotificationCenter.default.post(name: ComponentCollectionViewEvent.DidSelect,
                                            object: self)
        }
    }
}
