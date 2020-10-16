//
//  CategoryCollectionViewCell.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/10.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "categoryCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            changeBackgroundColor()
            sendNotification(oldValue)
        }
    }
    
    private func changeBackgroundColor() {
        if isSelected {
            backgroundColor = UIColor(named: "SelectedColor")
        } else {
            backgroundColor = .clear
        }
    }
    
    private func sendNotification(_ oldValue: Bool) {
        if oldValue == false && isSelected == true {
            NotificationCenter.default.post(name: .ChangedSelection, object: nil)
        }
    }
}

extension Notification.Name {
    static let ChangedSelection = Notification.Name("changedSelection")
}
