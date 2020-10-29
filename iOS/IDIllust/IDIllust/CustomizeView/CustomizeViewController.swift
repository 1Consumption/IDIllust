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
    @IBOutlet private weak var thumbnailView: UIView!
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var componentsStackView: UIStackView!
    @IBOutlet private weak var componentScrollView: UIScrollView!
    @IBOutlet private weak var colorSelectView: UIView!
    private var componentCollectionViews: [ComponentCollectionView] = [ComponentCollectionView]()
    private var componentCollectionViewDataSources: [ComponentCollectionViewDataSource] = [ComponentCollectionViewDataSource]()
    private var thumbnailImageView: [UIImageView] = [UIImageView]()
    private var componentCollectionViewDelegate: ComponentCollectionViewDelegate? = ComponentCollectionViewDelegate()
    private let categoryCollectionViewDataSource: CategoryCollectionViewDataSource = CategoryCollectionViewDataSource()
    private let categoryComponentManager: CategoryComponentManager = CategoryComponentManager()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserves()
        setCategoriesUseCase()
        componentScrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        componentCollectionViewDelegate = nil
    }
    
    // MARK: - Methods
    private func setCategoryCollectionView() {
        categoryCollectionView.setSquarCell(factor: categoryCollectionView.frame.height)
        categoryCollectionView.dataSource = categoryCollectionViewDataSource
        categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    private func setComponentCollectionViews() {
        guard let count = categoryComponentManager.categoryCount else { return }
        
        for _ in 0..<count {
            let dataSource = ComponentCollectionViewDataSource()
            componentCollectionViewDataSources.append(dataSource)
            let collectionView = ComponentCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            componentCollectionViews.append(collectionView)
            componentsStackView.addArrangedSubview(collectionView)
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
            collectionView.dataSource = dataSource
            collectionView.backgroundColor = .systemBackground
            collectionView.delegate = componentCollectionViewDelegate
        }
    }
    
    private func addThumbnailImageViews() {
        guard let count = categoryComponentManager.categoryCount else { return }
        
        for _ in 0..<count {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            thumbnailView.addSubview(imageView)
            imageView.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: thumbnailView.centerXAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: thumbnailView.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: thumbnailView.heightAnchor).isActive = true
            thumbnailImageView.append(imageView)
        }
    }
    
    private func addObserves() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollComponentScrollView),
                                               name: .ChangedSelection,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(categoryComponentManagerEventHandler(_:)),
                                               name: CategoryComponentManagerEvent.ModelChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentCollectionViewEventHandler(_:)),
                                               name: ComponentCollectionViewEvent.LongPressGestureStateChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentCollectionViewEventHandler(_:)),
                                               name: ComponentCollectionViewEvent.DidSelect,
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
    
    private func tasksForCategoryChanged() {
        categoryCollectionViewDataSource.categories = categoryComponentManager.categories
        DispatchQueue.main.async { [weak self] in
            self?.setCategoryCollectionView()
            self?.setComponentCollectionViews()
            self?.addThumbnailImageViews()
        }
        setComponentsUseCase(categoryComponentManager.category(of: 0)?.id)
    }
    
    private func reloadComponentsCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let selected = self?.categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return }
            guard let categoryId = self?.categoryComponentManager.category(of: selected)?.id else { return }
            self?.componentCollectionViewDataSources[selected].components = self?.categoryComponentManager.components(of: categoryId)
            self?.componentCollectionViews[selected].reloadData()
        }
    }
    
    private func setColorSelectViewFrame(origin: CGPoint) {
        guard let colorSelectVC = children.first as? ColorSelectViewController else { return }
        colorSelectView.frame = CGRect(origin: origin, size: colorSelectVC.colorSelectCollectionView.contentSize)
    }
    
    private func correct(point: inout CGPoint) {
        point.y -= colorSelectView.frame.height / 1.5
        
        guard point.x + colorSelectView.frame.width >= view.frame.width else { return }
        
        point.x = view.frame.width - colorSelectView.frame.width
    }
    
    private func showColorSelectView(_ point: CGPoint) {
        guard let selected = categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return }
        var convertedPoint = point.convert(to: [componentCollectionViews[selected], componentsStackView, view])
        
        correct(point: &convertedPoint)
        
        setColorSelectViewFrame(origin: convertedPoint)
        
        colorSelectView.isHidden = false
        UIDevice.vibrate(style: .light)
    }
    
    private func hideColorSelectView() {
        colorSelectView.isHidden = true
    }
    
    // MARK: @objc
    @objc func scrollComponentScrollView() {
        guard let selected = categoryCollectionView.indexPathsForSelectedItems?.first else { return }
        let index = selected.item
        
        let willX = index * Int(view.frame.width)
        let currentX = Int(componentScrollView.contentOffset.x)
        
        guard willX != currentX else { return }
        
        categoryCollectionView.selectItem(at: selected, animated: true, scrollPosition: .centeredHorizontally)
        componentScrollView.setContentOffset(CGPoint(x: willX, y: 0), animated: true)
        
        guard let categoryId = categoryComponentManager.category(of: index)?.id else { return }
        guard categoryComponentManager.isExistComponents(with: categoryId) else {
            setComponentsUseCase(categoryComponentManager.category(of: index)?.id)
            return
        }
    }
    
    @objc private func categoryComponentManagerEventHandler(_ notification: Notification) {
        guard let object = notification.object as? CategoryComponentManagerEvent else { return }
        switch object {
        case .categoryChanged: tasksForCategoryChanged()
        case .componentsAppended: reloadComponentsCollectionView()
        }
    }
    
    @objc private func componentCollectionViewEventHandler(_ notification: Notification) {
        guard let object = notification.object as? ComponentCollectionViewEvent else { return }
        
        switch object {
        case .longPressBegan(let origin, _): showColorSelectView(origin)
        case .longPressEnded: hideColorSelectView()
        case .didSelect(let indexPath): print(indexPath)
        default: break
        }
    }
}

extension CustomizeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let curX = scrollView.contentOffset.x
        let width = view.frame.width
        let index = Int(curX / width)
        
        guard (curX.truncatingRemainder(dividingBy: width)) == 0 else { return }
        
        guard let selected = categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return }
        
        guard selected != index else { return }
        
        categoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        guard let categoryId = categoryComponentManager.category(of: index)?.id else { return }
        
        guard categoryComponentManager.isExistComponents(with: categoryId) else {
            setComponentsUseCase(categoryComponentManager.category(of: index)?.id)
            return
        }
    }
}
