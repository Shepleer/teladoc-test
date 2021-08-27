//
//  NCHTTPMethod.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 17/08/2021.
//

import Foundation

enum NCHTTPMethod: RawRepresentable, Equatable {
    typealias RawValue = String
    
    case get
    case post
    case put
    case delete
    
    var rawValue: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .delete:
                return "DELETE"
        }
    }
    
    init?(rawValue: String) {
        switch rawValue {
            case "GET":
                self = .get
            case "POST":
                self = .post
            case "PUT":
                self = .put
            case "DELETE":
                self = .delete
            default:
                return nil
        }
    }
}

