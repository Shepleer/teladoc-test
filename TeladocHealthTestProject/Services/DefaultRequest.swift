//
//  DefaultRequest.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 30/08/2021.
//

import Foundation

struct DefaultRequest: RequestModel {
    var customURL: URL?
    var host: String?
    var path: String
    var method: NCHTTPMethod = .get
    var headers: [String : String] = ["Content-Type": "application/json"]
    var parameters: [String: Any]? = nil
    var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData
    var retryPolicy: RetryPolicy = .noRetry
    var timeoutInterval: TimeInterval = 30
    
    init(path: String) {
        self.path = path
    }
    
    init(url: URL) {
        self.customURL = url
        self.path = ""
    }
}
