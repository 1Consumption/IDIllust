//
//  NetworkManager.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/10/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

final class NetworkManager: NetworkManageable {

    @discardableResult
    func getResource(url: URL?, method: HTTPMethod, headers: HTTPHeaders?, handler: @escaping DataHandler) -> URLSessionDataTask? {
        guard let urlRequest = makeURLRequest(url: url, method: method, headers: headers) else {
            handler(.failure(.emptyURL))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                handler(.failure(.requestError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                handler(.failure(.invalidHTTPResonse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                handler(.failure(.invalidStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                handler(.failure(.dataEmpty))
                return
            }
            
            handler(.success(data))
        }
        
        task.resume()
        
        return task
    }
    
    private func makeURLRequest(url: URL?, method: HTTPMethod, headers: HTTPHeaders?) -> URLRequest? {
        guard let url = url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        headers?.list.forEach { field, value in
            urlRequest.addValue(value, forHTTPHeaderField: field)
        }
        
        return urlRequest
    }
}
