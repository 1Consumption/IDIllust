//
//  CurrentSelection.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust

extension CurrentSelection: Equatable {
    public static func == (lhs: CurrentSelection, rhs: CurrentSelection) -> Bool {
        return lhs.categoryIndex == rhs.categoryIndex && lhs.categoryId == rhs.categoryId && lhs.componentId == rhs.componentId
    }
}
