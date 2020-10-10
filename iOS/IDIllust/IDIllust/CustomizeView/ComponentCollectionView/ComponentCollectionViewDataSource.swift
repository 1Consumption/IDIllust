//
//  ComponentCollectionViewDataSource.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/11.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

class ComponentCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComponentCollectionViewCell.identifier, for: indexPath) as? ComponentCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = #imageLiteral(resourceName: "ic_hair_1")
        return cell
    }
}
