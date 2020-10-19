//
//  EntryImageUseCase.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct EntryImageUseCase {
    
    @discardableResult
    public func retrieveEntryImageInfo(networkManager: NetworkManageable, failureHandler: @escaping (NetworkError) -> Void = { _ in }, successHandler: @escaping (EntryImage) -> Void) -> URLSessionDataTask? {
        let endPoint = EndPoint(path: .entry)
        
        let task = networkManager.getResource(url: endPoint.url,
                                              method: .get,
                                              headers: nil,
                                              handler: { result in
                                                switch result {
                                                case .success(let data):
                                                    do {
                                                        let model = try JSONDecoder().decode(EntryImage.self, from: data)
                                                        successHandler(model)
                                                    } catch {
                                                        failureHandler(.decodeError)
                                                    }
                                                    
                                                case .failure(let error):
                                                    failureHandler(error)
                                                }
                                              })
        
        return task
    }
}
