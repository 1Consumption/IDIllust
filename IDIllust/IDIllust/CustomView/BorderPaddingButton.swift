//
//  BorderPaddingButton.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/09/04.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

@IBDesignable
final class BorderPaddingButton: UIButton {

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
    
    // MARK: Padding
    @IBInspectable public var paddingWidth: CGFloat {
        get { padding.width }
        set { padding.width = newValue }
    }
    @IBInspectable public var paddingHeight: CGFloat {
        get { padding.height }
        set { padding.height = newValue }
    }
    
    // MARK: - Properties
    override var intrinsicContentSize: CGSize {
        let superIntrisicContentSize = super.intrinsicContentSize
        let width = superIntrisicContentSize.width + padding.width
        let height = superIntrisicContentSize.height + padding.height
        return CGSize(width: width, height: height)
    }
    private var padding: CGSize = CGSize(width: 0, height: 0)
    private var isClicked: Bool = false
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    // MARK: - Methods
    private func setUp() {
        self.addTarget(self, action: #selector(animate(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(animate(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(animate(_:)), for: .touchUpOutside)
    }
    
    private func scaleUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .allowUserInteraction, animations: {
            sender.transform = .identity
        })
    }
    
    private func scaleDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .allowUserInteraction, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
    }
    
    // MARK: - Objc
    @objc private func animate(_ sender: UIButton) {
        isClicked.toggle()
        isClicked ? scaleDown(sender) : scaleUp(sender)
    }
}
