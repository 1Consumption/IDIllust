//
//  ComponentsUseCase.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/23.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct ComponentsUseCase<T>: RetrieveModelFromServer where T: Codable {
    
    typealias Model = T
    
    @discardableResult
    func retrieveComponents(networkManager: NetworkManageable, categoryId: Int, failurehandler: @escaping (UseCaseError) -> Void = { _ in }, successHandler: @escaping (Model) -> Void) -> URLSessionDataTask? {
        let endPoint = EndPoint(path: .components(categoryId))
        
        return retrieveModel(from: endPoint, networkManager: networkManager, failurehandler: failurehandler, successHandler: successHandler)
    }
}
