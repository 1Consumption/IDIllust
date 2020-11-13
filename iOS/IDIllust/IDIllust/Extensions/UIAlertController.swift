//
//  UIAlertController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/13.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

extension UIAlertController {
    func confirmAlert(title: String, message: String) -> UIAlertController {
        let confirm = UIAlertController(title: title, message: message, preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        return confirm
    }
}
