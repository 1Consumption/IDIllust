//
//  ComponentCollectionView.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/15.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

class ComponentCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registGesture()
    }
    
    private func registGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressed(_:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc func pressed(_ recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: self)
        
        switch recognizer.state {
        case .ended: print("LongPress Ended \(point)")
            
        case .began:
            guard let indexPath = indexPathForItem(at: point) else { return }
            guard let origin = cellForItem(at: indexPath)?.frame.origin else { return }
            
            NotificationCenter.default.post(name: .LongPressBegan,
                                            object: nil,
                                            userInfo: ["point": origin, "indexPath": indexPath])
            
        case .changed: print("LongPress Changed \(point)")
            
        default: break
        }
    }
}

extension Notification.Name {
    static let LongPressBegan = Notification.Name("longPressBegan")
}
