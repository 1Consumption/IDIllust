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
    func retrieveThumbnail(with categoryId: Int, _ componentId: Int, networkManager: NetworkManageable, failurehandler: @escaping (UseCaseError) -> Void = { _ in }, successHandler: @escaping (Model) -> Void) -> URLSessionDataTask? {
        let endPoint = EndPoint(path: .thumbnail(categoryId, componentId))
        
        return retrieveModel(from: endPoint, networkManager: networkManager, failurehandler: failurehandler, successHandler: successHandler)
    }
}
