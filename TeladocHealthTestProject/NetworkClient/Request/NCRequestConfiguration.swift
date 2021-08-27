//
//  NCRequestConfiguration.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 18/08/2021.
//

import Foundation

protocol RequestModel: RequestConfiguration {
    // if we need pass a not host based url we cab use this
    var customURL: URL? { get set }
    var path: String { get }
}

protocol RequestConfiguration {
    var method: NCHTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var retryPolicy: RetryPolicy { get }
    var timeoutInterval: TimeInterval { get }
}

//protocol RequestResponseModel {
//    associatedtype ResponseModel: Decodable
//    associatedtype ErrorModel: Decodable
//
//    var responseModel: ResponseModel.Type { get }
//    var errorModel: ErrorModel.Type { get }
//}

//extension RequestResponseModel {
//    var responseModel: ResponseModel.Type {
//        ResponseModel.self
//    }
//
//    var errorModel: ErrorModel.Type {
//        ErrorModel.self
//    }
//}

enum RetryPolicy {
    case noRetry
    case retry(_ times: Int)
}
