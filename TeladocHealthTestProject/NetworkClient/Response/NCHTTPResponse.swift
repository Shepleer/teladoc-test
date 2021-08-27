//
//  NCHTTPResponse.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 18/08/2021.
//

import Foundation

struct NCResponse {
    let taskId: Int
    let statusCode: Int
    let data: Data?
    let error: Error?
    
    var classification: NCHTTPResponseStatusClassification {
        .init(rawValue: statusCode)
    }
}

enum NCHTTPResponseStatusClassification: Int, RawRepresentable, Equatable {
    case info
    case success
    case redirect
    case clientError
    case serverError
    case unknown

    init(rawValue: Int) {
        switch rawValue {
            case (100...199):
                self = .info
            case (200...299):
                self = .success
            case (300...399):
                self = .redirect
            case (400...499):
                self = .clientError
            case (500...599):
                self = .clientError
            default:
                self = .unknown
        }
    }
}
