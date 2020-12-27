//
//  AcitivityIndicatorDisplayable.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/12/26.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

protocol ActivityIndicatorDisplayable: class {
    var activityIndicator: UIActivityIndicatorView { get }
    func addActivityIndicator()
    func startIndicator()
    func stopIndicator()
}

extension ActivityIndicatorDisplayable {
    func startIndicator() {
        guard !activityIndicator.isAnimating else { return }
        activityIndicator.startAnimating()
    }
    
    func stopIndicator() {
        activityIndicator.stopAnimating()
    }
}
