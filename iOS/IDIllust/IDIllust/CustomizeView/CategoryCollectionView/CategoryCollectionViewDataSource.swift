//
//  CategoryCollectionViewDataSource.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/11.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Kingfisher
import UIKit

final class CategoryCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var model: Categories?
    var modelCount: Int { return model?.categories.count ?? 0 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        guard let url = model?.category(of: indexPath.item)?.url else { return cell }
        
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: URL(string: url))
        
        if collectionView.indexPathsForSelectedItems == nil && indexPath.row == 0 {
            cell.isSelected = true
        }
        
        return cell
    }
}
