//
//  MockNetworkManagers.swift
//  IDIllustTests
//
//  Created by 신한섭 on 2020/10/24.
//  Copyright © 2020 신한섭. All rights reserved.
//

@testable import IDIllust
import Foundation

class MockSuccessNetworkManager<T>: NetworkManageable where T: Codable {
    
    private let model: T!
    
    init(model: T) {
        self.model = model
    }
    
    func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
        let data = try! JSONEncoder().encode(model)
        handler(.success(data))
        return nil
    }
}

class MockDecodeFailureNetworkManager: NetworkManageable {
    
    struct DecodeErrorModel: Codable {
        let fake: String
    }
    
    func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
        let model = DecodeErrorModel(fake: "fake")
        let data = try! JSONEncoder().encode(model)
        handler(.success(data))
        return nil
    }
}

class MockNetworkFailureNetworkManager: NetworkManageable {
    
    func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
        handler(.failure(.requestError))
        return nil
    }
}
