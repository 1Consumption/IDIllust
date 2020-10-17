//
//  ColorSelectViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/17.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class ColorSelectViewController: UIViewController {
    
    // MARK: properties
    @IBOutlet weak var colorSelectCollectionView: UICollectionView!
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewLayout()
        colorSelectCollectionView.dataSource = self
    }
    
    // MARK: Methods
    private func setCollectionViewLayout() {
        let layout = colorSelectCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let height = colorSelectCollectionView.frame.height
        layout?.itemSize = CGSize(width: height, height: height)
        layout?.minimumLineSpacing = 0
        layout?.minimumLineSpacing = 0
    }
}

extension ColorSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSelectCollectionViewCell.identifier, for: indexPath) as? ColorSelectCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}
