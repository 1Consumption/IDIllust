//
//  ComponentCollectionView.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/15.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class ComponentCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registGesture()
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSquarCell(factor: frame.width, divide: 3)
        setSpacing(line: 0, interItem: 0)
    }
    
    private func setUpCollectionView() {
        translatesAutoresizingMaskIntoConstraints = false
        register(ComponentCollectionViewCell.self, forCellWithReuseIdentifier: ComponentCollectionViewCell.identifier)
    }
    
    private func registGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressed(_:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc func pressed(_ recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: self)
        
        switch recognizer.state {
        case .ended:
            NotificationCenter.default.post(name: .LongPressEnded,
                                            object: nil)
            
        case .began:
            guard let indexPath = indexPathForItem(at: point) else { return }
            guard let origin = cellForItem(at: indexPath)?.frame.origin else { return }
            
            NotificationCenter.default.post(name: .LongPressBegan,
                                            object: nil,
                                            userInfo: ["point": origin, "indexPath": indexPath])
            
        case .changed:
            NotificationCenter.default.post(name: .LongPressChanged,
                                            object: nil,
                                            userInfo: ["x": point.x])
            
        default: break
        }
    }
}

extension Notification.Name {
    static let LongPressBegan = Notification.Name("longPressBegan")
    static let LongPressEnded = Notification.Name("longPressEnded")
    static let LongPressChanged = Notification.Name("longPressChanged")
}
