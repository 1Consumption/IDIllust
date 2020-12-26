//
//  ThumbnailDisplayable.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/12/26.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

protocol ThumbnailDisplayable: ActivityIndicatorDisplayable {
    var thumbnailView: UIView { get }
    var thumbnailImageViews: [UIImageView] { get }
    func setUpThumbnailView()
    func addThumbnailImageViews(_ count: Int)
    func setThumbnailImageView(with index: Int, path: String)
    func resetImages()
}

extension ThumbnailDisplayable {
    func resetImages() {
        thumbnailImageViews.forEach {
            $0.image = nil
        }
    }
    
    func setThumbnailImageView(with index: Int, path: String) {
        thumbnailImageViews[index].kf.setImage(with: URL(string: path),
                                               options: [.keepCurrentImageWhileLoading],
                                               completionHandler: { [weak self] _ in
                                                self?.stopIndicator()
                                               })
    }
}
