//
//  Encodable+Dictionary.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 24/08/2021.
//

import Foundation

extension Encodable {
//    func makeDictionary() -> [String: Any]? where Self == Dictionary<String, AnyEncodable> {
//        self
//    }
    
    func makeDictionary() -> [String: Any]? {
        if let data = try? JSONEncoder().encode(self) {
            return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        }
        return nil
    }
}
