//
//  RetrieveModelFromServer.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/23.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

protocol RetrieveModelFromServer {
    associatedtype Model
    
    func retrieveModel(from endPoint: EndPoint, networkManager: NetworkManageable, failurehandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (Model) -> Void) -> URLSessionDataTask?
}

extension RetrieveModelFromServer where Model: Decodable {
    @discardableResult
    func retrieveModel(from endPoint: EndPoint, networkManager: NetworkManageable, failurehandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (Model) -> Void) -> URLSessionDataTask? {
        let url = endPoint.url
        
        let task = networkManager.getResource(url: url,
                                  method: .get,
                                  headers: nil,
                                  handler: { result in
                                    switch result {
                                    case .success(let data):
                                        do {
                                            let model = try JSONDecoder().decode(Model.self, from: data)
                                            successHandler(model)
                                        } catch {
                                            failurehandler(.decodeError)
                                        }
                                        
                                    case .failure(let error):
                                        failurehandler(.networkError(error))
                                    }
                                  })
        
        return task
    }
}
