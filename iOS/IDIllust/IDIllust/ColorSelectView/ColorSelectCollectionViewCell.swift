//
//  ColorSelectCollectionViewCell.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/17.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class ColorSelectCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "colorSelectCollectionViewCell"
    
    @IBOutlet weak var colorImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .link
            } else {
                backgroundColor = .clear
            }
        }
    }
}
