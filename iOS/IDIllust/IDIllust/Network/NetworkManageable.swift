//
//  NetworkManageable.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

protocol NetworkManageable {
    func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler : @escaping DataHandler) -> URLSessionDataTask?
}

typealias DataHandler = (Result<Data, NetworkError>) -> Void
