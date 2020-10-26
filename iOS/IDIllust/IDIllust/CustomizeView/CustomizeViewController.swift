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
    private var categories: Categories? {
        didSet {
            categoryCollectionViewDataSource.model = categories
            DispatchQueue.main.async { [weak self] in
                self?.setCategoryCollectionView()
                self?.setComponentCollectionViews()
            }
        }
    }
    private var componentsManager: ComponentsManager = ComponentsManager()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserves()
        setCategoriesUseCase()
        setComponentCollectionViews()
        componentScrollView.delegate = self
    }
    
    // MARK: - Methods
    private func setCategoryCollectionView() {
        categoryCollectionView.setSquarCell(factor: categoryCollectionView.frame.height)
        categoryCollectionView.dataSource = categoryCollectionViewDataSource
        categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
        setComponentsUseCase(categories?.category(of: 0)?.id)
    }
    
    private func setComponentCollectionViews() {
        for _ in 0..<categoryCollectionViewDataSource.modelCount {
            let dataSource = ComponentCollectionViewDataSource()
            componentCollectionViewDataSources.append(dataSource)
            let collectionView = ComponentCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(ComponentCollectionViewCell.self, forCellWithReuseIdentifier: ComponentCollectionViewCell.identifier)
            componentCollectionViews.append(collectionView)
            componentsStackView.addArrangedSubview(collectionView)
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
            collectionView.setSquarCell(factor: view.frame.width, divide: 3)
            collectionView.setSpacing(line: 0, interItem: 0)
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
    }
    
    private func setCategoriesUseCase() {
        CategoriesUseCase().retrieveCategories(networkManager: NetworkManager(),
                                               failureHandler: { _ in
                                                // Todo: UseCaseError에 따른 예외 처리
                                               },
                                               successHandler: { [weak self] in
                                                self?.categories = $0
                                               })
    }
    
    private func setComponentsUseCase(_ categoryId: Int?) {
        guard let categoryId = categoryId else { return }
        ComponentsUseCase().retrieveComponents(networkManager: NetworkManager(),
                                               categoryId: categoryId,
                                               failurehandler: { _ in
                                                // Todo: UseCaseError에 따른 예외 처리
                                               },
                                               successHandler: {
                                                self.componentsManager.append($0)
                                               })
    }
    
    private func reloadCategoryCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.categoryCollectionView.reloadData()
            self?.categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
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
        guard let item = notification.userInfo?["item"] as? Int else { return }
        guard let selected = categoryCollectionView.indexPathsForSelectedItems?.first else { return }
        
        if selected.item != item {
            categoryCollectionView.selectItem(at: IndexPath(item: item, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            setComponentsUseCase(categories?.category(of: item)?.id)
        }
    }
    
    @objc func scrollComponentScrollView() {
        guard let selected = categoryCollectionView.indexPathsForSelectedItems?.first else { return }
        let willX = selected.item * Int(view.frame.width)
        let currentX = Int(componentScrollView.contentOffset.x)
        
        if willX != currentX {
            setComponentsUseCase(categories?.category(of: selected.item)?.id)
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
                                            userInfo: ["item": index])
        }
    }
}

extension Notification.Name {
    static let ComponentScrollViewSrcolled = Notification.Name(rawValue: "componentScrollViewSrcolled")
}
