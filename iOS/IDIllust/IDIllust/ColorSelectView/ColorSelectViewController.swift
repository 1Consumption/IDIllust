//
//  ColorSelectViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/17.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

protocol ColorChangedDelegate: AnyObject {
    func completionHandler(_ colorSelectCollectionView: UICollectionView?)
}

final class ColorSelectViewController: UIViewController {
    
    // MARK: properties
    @IBOutlet weak var colorSelectCollectionView: UICollectionView!
    private let reloadQueue = DispatchQueue(label: "reloadQueue")
    weak var colorChangedDelegate: ColorChangedDelegate?
    var colors: [Color]? {
        didSet {
            reloadQueue.async {
                DispatchQueue.main.sync { [weak self] in
                    self?.colorSelectCollectionView.reloadData()
                }
            }
            
            reloadQueue.async { [weak self] in
                self?.colorChangedDelegate?.completionHandler(self?.colorSelectCollectionView)
            }
        }
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        setCollectionViewLayout()
        colorSelectCollectionView.dataSource = self
        colorSelectCollectionView.delegate = self
    }
    
    // MARK: Methods
    private func setCollectionViewLayout() {
        let height = colorSelectCollectionView.frame.height
        colorSelectCollectionView.setSquarCell(factor: min(height * 0.7, height - 20))
        colorSelectCollectionView.setSpacing(line: 0, interItem: 0)
    }
    
    private func setObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectCell(_:)),
                                               name: ComponentCollectionViewEvent.LongPressGestureStateChanged,
                                               object: nil)
    }
    
    // MARK: @objc
    @objc func selectCell(_ notification: Notification) {
        guard let object = notification.object as? ComponentCollectionViewEvent else { return }
        
        switch object {
        case .longPressChanged(let currentX):
            guard let parentView = parent?.view else { return }
            let calibratedX = currentX - view.convert(view.frame.origin, to: parentView).x
            
            guard let currentIndexPath = colorSelectCollectionView.indexPathForItem(at: CGPoint(x: calibratedX, y: view.frame.midY)) else { return }
            let selectedIndexPath = colorSelectCollectionView.indexPathsForSelectedItems?.first
            
            guard selectedIndexPath != currentIndexPath else { return }
                
            colorSelectCollectionView.selectItem(at: currentIndexPath, animated: false, scrollPosition: .left)
            UIDevice.vibrate(style: .light)
            
        case .longPressEnded:
        default: break
        }
    }
}

extension ColorSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSelectCollectionViewCell.identifier, for: indexPath) as? ColorSelectCollectionViewCell else { return UICollectionViewCell() }
        guard let url = colors?[indexPath.item].url else { return cell }
        cell.colorImageView.kf.indicatorType = .activity
        cell.colorImageView.kf.setImage(with: URL(string: url))
        return cell
    }
}

extension ColorSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
