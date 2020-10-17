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
    @IBOutlet weak var componentsStackView: UIStackView!
    @IBOutlet weak var componentScrollView: UIScrollView!
    @IBOutlet weak var colorSelectView: UIView!
    private var componentCollectionViews: [ComponentCollectionView] = [ComponentCollectionView]()
    private var categoryCollectionViewDataSource = CategoryCollectionViewDataSource()
    private var componentCollectionViewDataSource = ComponentCollectionViewDataSource()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserves()
        setCategoryCollectionView()
        setComponentCollectionViews()
        componentScrollView.delegate = self
    }
    
    // MARK: - Methods
    private func setSquarCell(_ collectionView: UICollectionView, factor: CGFloat, divide: CGFloat = 1) {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
        layout?.minimumLineSpacing = 0
        layout?.minimumInteritemSpacing = 0
        layout?.itemSize = CGSize(width: factor / divide, height: factor / divide)
    }
    
    private func setCategoryCollectionView() {
        setSquarCell(categoryCollectionView, factor: categoryCollectionView.frame.height)
        categoryCollectionView.dataSource = categoryCollectionViewDataSource
        categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    private func setComponentCollectionViews() {
        for _ in 0..<categoryCollectionViewDataSource.modelCount {
            let collectionView = ComponentCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(ComponentCollectionViewCell.self, forCellWithReuseIdentifier: ComponentCollectionViewCell.identifier)
            componentCollectionViews.append(collectionView)
            componentsStackView.addArrangedSubview(collectionView)
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
            setSquarCell(collectionView, factor: view.frame.width, divide: 3)
            collectionView.dataSource = componentCollectionViewDataSource
        }
    }
    
    private func addObserves() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollCategoryCollectionView(_:)),
                                               name: .ComponentScrollViewSrcolled,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollComponentScrollView),
                                               name: .ChangedSelection,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showColorSelectView(_:)),
                                               name: .LongPressBegan,
                                               object: nil)
    }
    
    private func convert(point: CGPoint, to views: [UIView]) -> CGPoint {
        var converted: CGPoint = point
        for index in 0..<views.count - 1 {
            converted = views[index].convert(converted, to: views[index + 1])
        }
        
        return converted
    }
    
    private func setColorSelectViewSize() {
        guard let colorSelectVC = children.first as? ColorSelectViewController else { return }
        colorSelectView.frame.size = colorSelectVC.colorSelectCollectionView.contentSize
    }
    
    private func correct(point: inout CGPoint) {
        point.y -= colorSelectView.frame.height / 1.5
        
        guard point.x + colorSelectView.frame.width >= view.frame.width else { return }
        
        point.x = view.frame.width - colorSelectView.frame.width
    }
    
    // MARK: @objc
    @objc func scrollCategoryCollectionView(_ notification: Notification) {
        guard let row = notification.userInfo?["row"] as? Int else { return }
        guard let selected = categoryCollectionView.indexPathsForSelectedItems else { return }
        
        if selected[0].row != row {
            categoryCollectionView.selectItem(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    @objc func scrollComponentScrollView() {
        guard let selected = categoryCollectionView.indexPathsForSelectedItems else { return }
        let willX = selected[0].row * Int(view.frame.width)
        let currentX = Int(componentScrollView.contentOffset.x)
        
        if willX != currentX {
            componentScrollView.setContentOffset(CGPoint(x: willX, y: 0), animated: true)
        }
    }
    
    @objc func showColorSelectView(_ notification: Notification) {
        guard let point = notification.userInfo?["point"] as? CGPoint else { return }
        guard let selected = categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return }
        var convertedPoint = convert(point: point, to: [componentCollectionViews[selected], componentsStackView, view])
    
        setColorSelectViewSize()
        correct(point: &convertedPoint)
        
        colorSelectView.frame = CGRect(origin: convertedPoint, size: colorSelectView.frame.size)
    }
}

extension CustomizeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let curX = scrollView.contentOffset.x
        let width = view.frame.width
        let index = Int(curX / width)
        
        if (curX.truncatingRemainder(dividingBy: width)) == 0 {
            NotificationCenter.default.post(name: .ComponentScrollViewSrcolled,
                                            object: nil,
                                            userInfo: ["row": index])
        }
    }
}

extension Notification.Name {
    static let ComponentScrollViewSrcolled = Notification.Name(rawValue: "componentScrollViewSrcolled")
}
