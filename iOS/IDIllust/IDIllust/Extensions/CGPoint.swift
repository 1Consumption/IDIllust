//
//  CGPoint.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/29.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

extension CGPoint {
    func convert(to views: [UIView]) -> CGPoint {
        var converted: CGPoint = self
        for index in 0..<views.count - 1 {
            converted = views[index].convert(converted, to: views[index + 1])
        }
        
        return converted
    }
}
