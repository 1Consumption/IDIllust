//
//  ComponentCollectionViewCell.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/11.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

class ComponentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var isSelectedImageView: UIImageView!
    static let identifier: String = "componentCell"
    
    override var isSelected: Bool {
        didSet {
            setHiddentSelectedImageView()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelectedImageView.isHidden = true
    }
    
    private func setHiddentSelectedImageView() {
        isSelectedImageView.isHidden = !isSelected
    }
}
