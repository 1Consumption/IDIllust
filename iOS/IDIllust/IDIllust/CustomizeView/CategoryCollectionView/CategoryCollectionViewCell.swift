//
//  CategoryCollectionViewCell.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/10.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "categoryCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            changeBackgroundColor()
            // Todo: 이미 선택되어 있는 상태에서 다시 선택된 경우는 노티피케이션을 보내지 않도록 구현
        }
    }
    
    private func changeBackgroundColor() {
        if isSelected {
            backgroundColor = UIColor(named: "SelectedColor")
        } else {
            backgroundColor = .clear
        }
    }
}
