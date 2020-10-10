//
//  CustomizeViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/09/06.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class CustomizeViewController: UIViewController {
    
    // MARK: - IBOutles
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var componentCollectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViews()
    }
    
    // MARK: - Methods
    private func setSquarCell(_ collectionView: UICollectionView, factor: CGFloat, divide: CGFloat = 1) {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: factor / divide, height: factor / divide)
    }
    
    private func setCollectionViews() {
        setSquarCell(categoryCollectionView, factor: categoryCollectionView.frame.height)
        setSquarCell(componentCollectionView, factor: componentCollectionView.frame.width, divide: 3)
        categoryCollectionView.dataSource = self
        componentCollectionView.dataSource = self
    }
}

extension CustomizeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
            
            cell.backgroundColor = .red
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "componentCell", for: indexPath)
            cell.backgroundColor = .red
            return cell
        }
    }
}
