//
//  NCError.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 18/08/2021.
//

import Foundation

enum NCError: Error {
    enum RequestBuildErrorReason {
        case wrongURL
        case invalidRequestModel
        case unknownError
        
        var description: String {
            "TODO: write description"
        }
    }
    
    enum RequestNetworkErrorReason {
        case badStatusCode(_ statusCode: Int)
        case urlSessionError(_ error: Error)
        case emptyResponse
        
        var description: String {
            "TODO: write description"
        }
    }
    
    enum ReqeustParsingErrorReason {
        case invalidResponseModel
        case invalidErrorModel
        
        var description: String {
            "TODO: write description"
        }
    }
    
    case requestBuildError(_ reason: RequestBuildErrorReason)
    case networkError(_ reason: RequestNetworkErrorReason)
    case parsingError(_ reason: ReqeustParsingErrorReason)
    
    var description: String {
        switch self {
            case .requestBuildError(let reason):
                return "Network Layer was failed on building request step. Reason: \(reason.description)"
            case .networkError(let reason):
                return "Network Layer was failed. Reason: \(reason.description)"
            case .parsingError(let reason):
                return "bla bla bla. Reason: \(reason.description)"
        }
    }
}
