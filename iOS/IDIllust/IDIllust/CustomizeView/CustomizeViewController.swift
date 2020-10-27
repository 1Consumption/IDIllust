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
    private var componentCollectionViewDataSources = [ComponentCollectionViewDataSource]()
    private var categoryComponentManager: CategoryComponentManager = CategoryComponentManager()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserves()
        setCategoriesUseCase()
        componentScrollView.delegate = self
    }
    
    // MARK: - Methods
    private func setCategoryCollectionView() {
        categoryCollectionView.setSquarCell(factor: categoryCollectionView.frame.height)
        categoryCollectionView.dataSource = categoryCollectionViewDataSource
        categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    private func setComponentCollectionViews() {
        for _ in 0..<categoryCollectionViewDataSource.modelCount {
            let dataSource = ComponentCollectionViewDataSource()
            componentCollectionViewDataSources.append(dataSource)
            let collectionView = ComponentCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            componentCollectionViews.append(collectionView)
            componentsStackView.addArrangedSubview(collectionView)
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
            collectionView.dataSource = dataSource
            collectionView.backgroundColor = .systemBackground
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tasksForCategoryChanged),
                                               name: .CategoryChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadComponentsCollectionView),
                                               name: .ComponentsAppended,
                                               object: nil)
    }
    
    private func setCategoriesUseCase() {
        CategoriesUseCase().retrieveCategories(networkManager: NetworkManager(),
                                               failureHandler: { _ in
                                                // Todo: UseCaseError에 따른 예외 처리
                                               },
                                               successHandler: { [weak self] in
                                                self?.categoryComponentManager.insert(categories: $0)
                                               })
    }
    
    private func setComponentsUseCase(_ categoryId: Int?) {
        guard let categoryId = categoryId else { return }
        ComponentsUseCase().retrieveComponents(networkManager: NetworkManager(),
                                               categoryId: categoryId,
                                               failurehandler: { _ in
                                                // Todo: UseCaseError에 따른 예외 처리
                                               },
                                               successHandler: { [weak self] in
                                                self?.categoryComponentManager.insert(components: $0, by: categoryId)
                                               })
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
        guard let item = notification.userInfo?["item"] as? Int else { return }
        guard let selected = categoryCollectionView.indexPathsForSelectedItems?.first else { return }
        
        if selected.item != item {
            categoryCollectionView.selectItem(at: IndexPath(item: item, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            
            guard let categoryId = categoryComponentManager.category(of: item)?.id else { return }
            guard categoryComponentManager.isExistComponents(with: categoryId) else {
                setComponentsUseCase(categoryComponentManager.category(of: item)?.id)
                return
            }
        }
    }
    
    @objc func scrollComponentScrollView() {
        guard let index = categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return }
        let willX = index * Int(view.frame.width)
        let currentX = Int(componentScrollView.contentOffset.x)
        
        if willX != currentX {
            componentScrollView.setContentOffset(CGPoint(x: willX, y: 0), animated: true)
            guard let categoryId = categoryComponentManager.category(of: index)?.id else { return }
            guard categoryComponentManager.isExistComponents(with: categoryId) else {
                setComponentsUseCase(categoryComponentManager.category(of: index)?.id)
                return
            }
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
    
    @objc func tasksForCategoryChanged() {
        categoryCollectionViewDataSource.model = categoryComponentManager.categories
        DispatchQueue.main.sync { [weak self] in
            self?.setCategoryCollectionView()
            self?.setComponentCollectionViews()
        }
        setComponentsUseCase(categoryComponentManager.category(of: 0)?.id)
    }
    
    @objc func reloadComponentsCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let selected = self?.categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return }
            guard let categoryId = self?.categoryComponentManager.category(of: selected)?.id else { return }
            self?.componentCollectionViewDataSources[selected].components = self?.categoryComponentManager.components(of: categoryId)
            self?.componentCollectionViews[selected].reloadData()
        }
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
                                            userInfo: ["item": index])
        }
    }
}

extension Notification.Name {
    static let ComponentScrollViewSrcolled = Notification.Name(rawValue: "componentScrollViewSrcolled")
}
