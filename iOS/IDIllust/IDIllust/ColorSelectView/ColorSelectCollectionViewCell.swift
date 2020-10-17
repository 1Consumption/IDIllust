//
//  ColorSelectCollectionViewCell.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/17.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class ColorSelectCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBInspectable
    @IBInspectable public var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable public var borderColor: UIColor {
        get { UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue.cgColor }
    }
    
    // MARK: CornerRadius
    @IBInspectable public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
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
