//
//  TutorialViewModel.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/16.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

final class TutorialViewModel {
    
    private let currentPage: Dynamic<Int> = Dynamic<Int>()
    
    func setPage(_ page: Int) {
        currentPage.value = page
    }
    
    func bindCurrentPage(handler: @escaping Dynamic<Int>.Handler) {
        currentPage.bind(handler)
    }
    
    func fireCurrentPage() {
        currentPage.fire()
    }
}
