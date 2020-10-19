//
//  UseCaseError.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

enum UseCaseError: Error {
    case networkError(NetworkError)
    case decodeError
    
    func message() -> String {
        switch self {
        case .networkError(let error):
            return error.message()
            
        case .decodeError:
            return "응답을 복호화 하는 도중 문제가 발생했어요."
        }
    }
}
