//
//  CustomizeViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/09/06.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

typealias LayerOrder = Int

final class CustomizeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var thumbnailView: UIView!
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var componentsStackView: UIStackView!
    @IBOutlet private weak var componentScrollView: UIScrollView!
    @IBOutlet private weak var colorSelectView: UIView!
    @IBAction func doneButtonPushed(_ sender: Any) {
        guard let storeViewController = storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as? StoreViewController else { return }
        storeViewController.modalPresentationStyle = .overCurrentContext
        storeViewController.layerInfo = resultBySelection()
        show(storeViewController, sender: self)
    }
    
    private var componentCollectionViews: [ComponentCollectionView] = [ComponentCollectionView]()
    private var componentCollectionViewDataSources: [ComponentCollectionViewDataSource] = [ComponentCollectionViewDataSource]()
    private var thumbnailImageViews: [UIImageView] = [UIImageView]()
    private let categoryCollectionViewDataSource: CategoryCollectionViewDataSource = CategoryCollectionViewDataSource()
    private let categoryComponentManager: CategoryComponentManager = CategoryComponentManager()
    private let selectionManager: SelectionManager = SelectionManager()
    
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
    
    private func setComponentCollectionViews(_ count: Int) {
        for _ in 0..<count {
            let dataSource = ComponentCollectionViewDataSource()
            componentCollectionViewDataSources.append(dataSource)
            let collectionView = ComponentCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            componentCollectionViews.append(collectionView)
            componentsStackView.addArrangedSubview(collectionView)
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
            collectionView.dataSource = dataSource
            collectionView.backgroundColor = .systemBackground
            collectionView.delegate = self
        }
    }
    
    private func addThumbnailImageViews(_ count: Int) {
        for _ in 0..<count {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            thumbnailView.addSubview(imageView)
            imageView.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: thumbnailView.centerXAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: thumbnailView.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: thumbnailView.heightAnchor).isActive = true
            thumbnailImageViews.append(imageView)
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
                                                self?.categoryComponentManager.insert($0)
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
                                                self?.categoryComponentManager.insert($0, by: categoryId)
                                               })
    }
    
    private func tasksForCategoryChanged() {
        categoryCollectionViewDataSource.categories = categoryComponentManager.categories
        guard let count = categoryComponentManager.categoryCount else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.setCategoryCollectionView()
            self?.setComponentCollectionViews(count)
            self?.addThumbnailImageViews(count)
        }
        
        let categoryId = categoryComponentManager.category(of: 0)?.id
        setComponentsUseCase(categoryId)
        selectionManager.setCurrentCategory(with: categoryId, for: 0)
    }
    
    private func reloadComponentsCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let selected = self?.categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return }
            guard let categoryId = self?.categoryComponentManager.category(of: selected)?.id else { return }
            self?.componentCollectionViewDataSources[selected].components = self?.categoryComponentManager.components(of: categoryId)
            self?.componentCollectionViews[selected].reloadData()
        }
    }
    
    private func setColorSelectViewFrame(size: CGSize?) {
        guard let size = size else { return }
        colorSelectView.frame = CGRect(origin: colorSelectView.frame.origin, size: size)
    }
    
    private func correctColorSelectViewOrigin() {
        var mutablePoint = colorSelectView.frame.origin
        
        mutablePoint.y -= colorSelectView.frame.height / 1.5
        
        if colorSelectView.frame.maxX >= view.frame.width {
            mutablePoint.x = view.frame.width - colorSelectView.frame.width
        }
        
        colorSelectView.frame = CGRect(origin: mutablePoint, size: colorSelectView.frame.size)
    }
    
    private func setColorSelectView(_ point: CGPoint, _ componentIndexPath: IndexPath) {
        guard let selected = selectionManager.current.categoryIndex else { return }
        guard let categoryId = selectionManager.current.categoryId else { return }

        let convertedPoint = componentCollectionViews[selected].convert(point, to: view)
        
        colorSelectView.frame = CGRect(origin: convertedPoint, size: colorSelectView.frame.size)
        
        guard let colorSelectViewController = children.first as? ColorSelectViewController else { return }
        
        let component = categoryComponentManager.component(with: categoryId, for: componentIndexPath.item)
        let colors = component?.colors
        
        colorSelectViewController.delegate = self
        colorSelectViewController.selectedId = selectionManager.colorSelectionForEachComponent[component?.id] ?? colors?.first?.id
        colorSelectViewController.colors = colors
        
        selectionManager.setCurrentComponentInfo(with: component?.id, for: componentIndexPath)
    }
    
    private func retrieveThumbnail(current: CurrentSelection) {
        ThumbnailUseCase().retrieveThumbnail(selectionManager.current, networkManager: NetworkManager(), successHandler: { model in
            DispatchQueue.main.async { [weak self] in
                guard let categoryId = current.categoryId else { return }
                guard var categoryIndex = current.categoryIndex else { return }
                
                self?.correct(categoryIndex: &categoryIndex)
                self?.selectionManager.setSelection(with: categoryId, for: model.thumbUrl)
                self?.thumbnailImageViews[categoryIndex].kf.setImage(with: URL(string: model.thumbUrl), options: [.keepCurrentImageWhileLoading])
            }
        })
    }
    
    private func correct(categoryIndex: inout Int) {
        guard let numOfCategories = categoryComponentManager.categoryCount else { return }
        
        categoryIndex += 1
        
        guard categoryIndex >= numOfCategories else { return }
        categoryIndex = 0
    }
    
    private func changeComponentSelection(_ categoryId: Int, _ componentId: Int) {
        if selectionManager.isSelectedComponent(with: categoryId, and: componentId) {
            selectionManager.removeCurrentComponent()
            guard var categoryIndex = selectionManager.current.categoryIndex else { return }
            componentCollectionViews[categoryIndex].selectItem(at: nil, animated: false, scrollPosition: .bottom)
            
            correct(categoryIndex: &categoryIndex)
            thumbnailImageViews[categoryIndex].image = nil
        } else {
            selectionManager.setCurrentComponentInfo(with: componentId)
            retrieveThumbnail(current: selectionManager.current)
        }
    }
    
    private func resultBySelection() -> [LayerOrder: String] {
        var result = [LayerOrder: String]()
        
        selectionManager.selection.forEach {
            guard var layerOrder = categoryComponentManager.firstIndex(of: $0.key) else { return }
            correct(categoryIndex: &layerOrder)
            
            result[layerOrder] = $0.value.thumbnailUrl
        }
        
        return result
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
        selectionManager.setCurrentCategory(with: categoryId, for: index)
        
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
        case .longPressBegan(let origin, let indexPath): setColorSelectView(origin, indexPath)
            
        case .didSelect(let indexPath):
            guard let categoryId = selectionManager.current.categoryId else { return }
            guard let componentId = categoryComponentManager.component(with: categoryId, for: indexPath.item)?.id else { return }
            
            changeComponentSelection(categoryId, componentId)
            
        default: break
        }
    }
}

extension CustomizeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ComponentCollectionViewEvent.didSelect(selectedIndexPath: indexPath).post()
    }
}

extension CustomizeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !(scrollView is UICollectionView) else { return }
        
        let curX = scrollView.contentOffset.x
        let width = view.frame.width
        let index = Int(curX / width)
        
        guard (curX.truncatingRemainder(dividingBy: width)) == 0 else { return }
        
        guard let selected = categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return }
        
        guard selected != index else { return }
        
        categoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        guard let categoryId = categoryComponentManager.category(of: index)?.id else { return }
        selectionManager.setCurrentCategory(with: categoryId, for: index)
        
        guard categoryComponentManager.isExistComponents(with: categoryId) else {
            setComponentsUseCase(categoryComponentManager.category(of: index)?.id)
            return
        }
    }
}

extension CustomizeViewController: ColorSelectViewControllerDelegate {
    func colorSelectCollectionViewReloaded(_ colorSelectCollectionView: UICollectionView?) {
        DispatchQueue.main.async { [weak self] in
            self?.setColorSelectViewFrame(size: colorSelectCollectionView?.contentSize)
            self?.correctColorSelectViewOrigin()
            self?.colorSelectView.isHidden = false
        }
        
        UIDevice.vibrate(style: .light)
    }
    
    func colorSelected(_ colorId: Int?) {
        selectionManager.setCurrentColor(with: colorId)
        guard let categoryIndex = selectionManager.current.categoryIndex else { return }
        let componentIndexPath = selectionManager.current.componentInfo?.componentIndexPath

        DispatchQueue.main.async { [weak self] in
            self?.componentCollectionViews[categoryIndex].selectItem(at: componentIndexPath, animated: false, scrollPosition: .right)
            self?.colorSelectView.isHidden = true
        }
        
        retrieveThumbnail(current: selectionManager.current)
    }
}
