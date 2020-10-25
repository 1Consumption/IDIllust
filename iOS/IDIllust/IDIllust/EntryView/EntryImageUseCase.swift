//
//  EntryImageUseCase.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct EntryImageUseCase: RetrieveModelFromServer {
    
    typealias Model = EntryImage
    
    @discardableResult
    func retrieveEntryImageInfo(networkManager: NetworkManageable, failureHandler: @escaping (UseCaseError) -> Void = { _ in }, successHandler: @escaping (EntryImage) -> Void) -> URLSessionDataTask? {
        let endPoint = EndPoint(path: .entry)
        
        return retrieveModel(from: endPoint, networkManager: networkManager, failurehandler: failureHandler, successHandler: successHandler)
    }
}
