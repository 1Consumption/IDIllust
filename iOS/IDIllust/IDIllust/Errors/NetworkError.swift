//
//  NetworkError.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case dataEmpty
    case invalidHTTPResonse
    case invalidStatusCode(Int)
    case emptyURL
    case requestError
    
    var message: String {
        switch self {
        case .dataEmpty:
            return "데이터가 비었어요."
        case .invalidHTTPResonse:
            return "HTTP 응답이 유효하지 않아요."
        case .invalidStatusCode(let code):
            return "HTTP 응답 \(code) 에러 발생했어요."
        case .emptyURL:
            return "URL이 유효하지 않아요."
        case .requestError:
            return "요청을 보내는 중에 오류가 발생했어요."
        }
    }
}
