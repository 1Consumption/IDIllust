//
//  ThumbnailUseCase.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/30.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct ThumbnailUseCase: RetrieveModelFromServer {
    
    typealias Model = Thumbnail
    
    @discardableResult
    func retrieveThumbnail(_ categoryId: Int?, _ componentId: Int?, networkManager: NetworkManageable, failurehandler: @escaping (UseCaseError) -> Void = { _ in }, successHandler: @escaping (Model) -> Void) -> URLSessionDataTask? {
        
        guard let categoryId = categoryId, let componentId = componentId else {
            failurehandler(.networkError(.requestError))
            return nil
        }
        
        let endPoint = EndPoint(path: .thumbnail(categoryId: categoryId, componentId: componentId))
        
        return retrieveModel(from: endPoint, networkManager: networkManager, failurehandler: failurehandler, successHandler: successHandler)
    }
}
