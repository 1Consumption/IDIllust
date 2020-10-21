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
    private var categories: Categories? {
        didSet {
            categoryCollectionViewDataSource.model = categories
            reloadCategoryCollectionView()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserves()
        setCategoryCollectionView()
        categoriesUseCase()
        setComponentCollectionViews()
        componentScrollView.delegate = self
    }
    
    // MARK: - Methods
    private func setCategoryCollectionView() {
        categoryCollectionView.setSquarCell(factor: categoryCollectionView.frame.height)
        categoryCollectionView.dataSource = categoryCollectionViewDataSource
    }
    
    private func setComponentCollectionViews() {
        for _ in 0..<categoryCollectionViewDataSource.modelCount {
            let collectionView = ComponentCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(ComponentCollectionViewCell.self, forCellWithReuseIdentifier: ComponentCollectionViewCell.identifier)
            componentCollectionViews.append(collectionView)
            componentsStackView.addArrangedSubview(collectionView)
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
            collectionView.setSquarCell(factor: view.frame.width, divide: 3)
            collectionView.setSpacing(line: 0, interItem: 0)
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideColorSelectView),
                                               name: .LongPressEnded,
                                               object: nil)
    }
    
    private func categoriesUseCase() {
        CategoriesUseCase()
            .retrieveCategories(networkManager: NetworkManager(),
                                failureHandler: { _ in
                                    // Todo: UseCaseError에 따른 예외 처리
                                },
                                successHandler: { [weak self] in
                                    self?.categories = $0
                                })
    }
    
    private func reloadCategoryCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.categoryCollectionView.reloadData()
            self?.categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        }
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
        
        colorSelectView.isHidden = false
        UIDevice.vibrate(style: .light)
    }
    
    @objc func hideColorSelectView() {
        colorSelectView.isHidden = true
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
