//
//  ThumbnailViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/12/26.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class ThumbnailViewController: UIViewController {
    
    let thumbnailView: UIView = UIView()
    var thumbnailImageViews: [UIImageView] = [UIImageView]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpThumbnailView()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        guard let parent = parent as? CustomizeViewController else { return }
        parent.thumbnailDelegate = self
    }
}

extension ThumbnailViewController: ThumbnailDisplayable {
    func setUpThumbnailView() {
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thumbnailView)
        thumbnailView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        thumbnailView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thumbnailView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        thumbnailView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func addThumbnailImageViews(_ count: Int) {
        (0..<count).forEach { _ in
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
    
    func addActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor, constant: thumbnailView.frame.height / 3).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: thumbnailView.centerXAnchor).isActive = true
    }
}
