//
//  NumOfItemsViewModel.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/18.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

final class NumOfItemsViewModel {
    
    private let hasItems: Dynamic<Bool> = Dynamic<Bool>()
    
    func setHasItems(count: Int?) {
        hasItems.value = count != 0
    }
    
    func bindHasItems(handler: @escaping Dynamic<Bool>.Handler) {
        hasItems.bind(handler)
    }
    
    func fireHasItems() {
        hasItems.fire()
    }
}
