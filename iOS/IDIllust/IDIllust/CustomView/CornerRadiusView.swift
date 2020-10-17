//
//  CornerRadiusView.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/18.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

@IBDesignable
final class CornerRadiusView: UIView {
    
    // MARK: - IBInspectables
    // MARK: Border
    @IBInspectable public var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable public var borderColor: UIColor {
        get { UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue.cgColor }
    }
    
    // MARK: CornerRadius
    @IBInspectable public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
