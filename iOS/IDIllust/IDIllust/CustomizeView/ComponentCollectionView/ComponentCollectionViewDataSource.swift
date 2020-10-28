//
//  ComponentCollectionViewDataSource.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/11.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Kingfisher
import UIKit

final class ComponentCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var components: Components?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return components?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComponentCollectionViewCell.identifier, for: indexPath) as? ComponentCollectionViewCell else { return UICollectionViewCell() }
        guard let url = components?.model(of: indexPath.item)?.url else { return cell }
        
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: URL(string: url))
        
        return cell
    }
}
