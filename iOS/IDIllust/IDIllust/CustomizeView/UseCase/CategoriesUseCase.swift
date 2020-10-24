//
//  CategoriesUseCase.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/21.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct CategoriesUseCase: RetrieveModelFromServer {
    
    typealias Model = Categories
    
    @discardableResult
    func retrieveCategories(networkManager: NetworkManageable, failureHandler: @escaping (UseCaseError) -> Void = { _ in }, successHandler: @escaping (Model) -> Void) -> URLSessionDataTask? {
        let endPoint = EndPoint(path: .categories)
        
        return retrieveModel(from: endPoint, networkManager: networkManager, failurehandler: failureHandler, successHandler: successHandler)
    }
}
