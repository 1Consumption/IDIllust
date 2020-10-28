//
//  ComponentColors.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/28.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust

extension ComponentColor: Equatable {
    public static func == (lhs: ComponentColor, rhs: ComponentColor) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.url == rhs.url
    }
}
