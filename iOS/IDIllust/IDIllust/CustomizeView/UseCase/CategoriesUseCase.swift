//
//  CategoriesUseCase.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct CategoriesUseCase {
    
    @discardableResult
    public func retrieveCategories(networkManager: NetworkManageable, failureHandler: @escaping (UseCaseError) -> Void = { _ in }, successHandler: @escaping (Categories) -> Void) -> URLSessionDataTask? {
        let endPoint = EndPoint(path: .categories)
        
        let task = networkManager.getResource(url: endPoint.url,
                                              method: .get,
                                              headers: nil,
                                              handler: { result in
                                                switch result {
                                                case .success(let data):
                                                    do {
                                                        let model = try JSONDecoder().decode(Categories.self, from: data)
                                                        successHandler(model)
                                                    } catch {
                                                        failureHandler(.decodeError)
                                                    }
                                                    
                                                case .failure(let error):
                                                    failureHandler(.networkError(error))
                                                }
                                              })
        
        return task
    }
}
