//
//  ComponentCollectionViewCell.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/11.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class ComponentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    public static let identifier: String = "componentCell"
    public var imageView: UIImageView = UIImageView()
    public var selectedImageView: UIImageView = UIImageView()
    
    override var isSelected: Bool {
        didSet {
            setHiddentSelectedImageView()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedImageView.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setHiddentSelectedImageView() {
        selectedImageView.isHidden = !isSelected
    }
    
    private func setLayout() {
        setImageViewLayout()
        setSelectedImageViewLayout()
    }
    
    private func setImageViewLayout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    private func setSelectedImageViewLayout() {
        contentView.addSubview(selectedImageView)
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        selectedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        selectedImageView.heightAnchor.constraint(equalTo: selectedImageView.widthAnchor).isActive = true
        selectedImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        selectedImageView.image = UIImage(systemName: "checkmark")
        selectedImageView.tintColor = .label
        selectedImageView.isHidden = true
    }
}
