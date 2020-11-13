//
//  Dynamic.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/10.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

final class Dynamic<T> {
    
    typealias Handler = (T?) -> Void
    private var handler: Handler?
    var value: T? {
        didSet {
            handler?(value)
        }
    }
    
    func bind(_ handler: Handler?) {
        self.handler = handler
    }
    
    func fire() {
        handler?(value)
    }
}
