//
//  UserDefaults.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/15.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let beginnerKey: String = "beginner"
    
    func saveEncodableObject<T: Encodable>(_ encodable: T, forKey key: String) {
        let encoded = try? JSONEncoder().encode(encodable)
        setValue(encoded, forKey: key)
    }
    
    func loadDecodableObject<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        let result = try? JSONDecoder().decode(type, from: data)
        
        return result
    }
}
