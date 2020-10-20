//
//  UICollectionView.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func setSquarCell(factor: CGFloat, divide: CGFloat = 1) {
        let layout = self.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
        layout?.itemSize = CGSize(width: factor / divide, height: factor / divide)
    }
    
    func setSpacing(line: CGFloat, interItem: CGFloat) {
        let layout = self.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = line
        layout?.minimumInteritemSpacing = interItem
    }
}
