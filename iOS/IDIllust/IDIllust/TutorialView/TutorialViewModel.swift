//
//  TutorialViewModel.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/16.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

final class TutorialViewModel {
    
    private let numOfPage: Int
    private let currentPage: Dynamic<Int> = Dynamic<Int>()
    private let buttonTitle: Dynamic<String> = Dynamic<String>()
    
    init(numOfPage: Int) {
        self.numOfPage = numOfPage
        buttonTitle.value = Localization.skip
    }
    
    func setPage(_ page: Int) {
        currentPage.value = page
        buttonTitle.value = (numOfPage - 1 == page) ? Localization.start : Localization.skip
    }
    
    func bindCurrentPage(handler: @escaping Dynamic<Int>.Handler) {
        currentPage.bind(handler)
    }
    
    func fireCurrentPage() {
        currentPage.fire()
    }
    
    func bindButtonTitle(handler: @escaping Dynamic<String>.Handler) {
        buttonTitle.bind(handler)
    }
    
    func fireButtonTitle() {
        buttonTitle.fire()
    }
}
