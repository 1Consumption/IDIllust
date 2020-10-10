//
//  CustomizeViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/09/06.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class CustomizeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var componentCollectionView: UICollectionView!
    private var categoryCollectionViewDataSource = CategoryCollectionViewDataSource()
    private var componentCollectionViewDataSource = ComponentCollectionViewDataSource()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViews()
    }
    
    // MARK: - Methods
    private func setSquarCell(_ collectionView: UICollectionView, factor: CGFloat, divide: CGFloat = 1) {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: factor / divide, height: factor / divide)
    }
    
    private func setCollectionViews() {
        setSquarCell(categoryCollectionView, factor: categoryCollectionView.frame.height)
        setSquarCell(componentCollectionView, factor: componentCollectionView.frame.width, divide: 3)
        categoryCollectionView.dataSource = categoryCollectionViewDataSource
        componentCollectionView.dataSource = componentCollectionViewDataSource
    }
}
