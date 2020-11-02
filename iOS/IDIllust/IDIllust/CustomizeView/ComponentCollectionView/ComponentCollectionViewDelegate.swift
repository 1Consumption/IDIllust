//
//  ComponentCollectionViewDelegate.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class ComponentCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ComponentCollectionViewEvent.didSelect(indexPath).post()
    }
}
