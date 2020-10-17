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
        setObservers()
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
    
    private func setObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectCell(_:)),
                                               name: .LongPressChanged,
                                               object: nil)
    }
    
    // MARK: @objc
    @objc func selectCell(_ notification: Notification) {
        guard let currentX = notification.userInfo?["x"] as? CGFloat else { return }
        guard let parentView = parent?.view else { return }
        let calibratedX = currentX - view.convert(view.frame.origin, to: parentView).x
        
        let currentIndexPath = colorSelectCollectionView.indexPathForItem(at: CGPoint(x: calibratedX, y: 0))
        let selectedIndexPath = colorSelectCollectionView.indexPathsForSelectedItems?.first
        
        guard selectedIndexPath != currentIndexPath else { return }
            
        colorSelectCollectionView.selectItem(at: currentIndexPath, animated: false, scrollPosition: .left)
        UIDevice.vibrate(style: .light)
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
