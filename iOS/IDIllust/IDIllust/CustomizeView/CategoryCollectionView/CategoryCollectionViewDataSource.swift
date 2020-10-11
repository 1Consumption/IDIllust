//
//  CategoryCollectionViewDataSource.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/11.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

class CategoryCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    let modelCount = 8
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = #imageLiteral(resourceName: "ic_category_1_hair")
        return cell
    }
}
