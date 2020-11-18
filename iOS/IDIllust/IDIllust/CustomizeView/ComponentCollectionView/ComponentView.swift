//
//  ComponentView.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/18.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class ComponentView: UIView {
    
    private(set) var button: UIButton = BorderPaddingButton()
    private(set) var collectionView: ComponentCollectionView = ComponentCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var dataSource: UICollectionViewDataSource? {
        get { return collectionView.dataSource }
        set { collectionView.dataSource = newValue }
    }
    var delegate: UICollectionViewDelegate? {
        get { return collectionView.delegate }
        set { collectionView.delegate = newValue }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCollectionView()
        setUpButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    private func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.backgroundColor = .systemBackground
    }
    
    private func setUpButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        button.backgroundColor = .black
        button.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        button.tintColor = .white
        button.isHidden = true
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition position: UICollectionView.ScrollPosition) {
        collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: position)
    }
}
