//
//  NCRetrier.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 18/08/2021.
//

import Foundation

protocol Retrier {
//    func shouldRetry(requestWith httpResponse: NCHTTPResponse) -> Bool
}

class NCRetrier: Retrier {
    let retryTimes: UInt
    let delay: TimeInterval
    
    init(retryTimes: UInt = 0, delay: TimeInterval = 0) {
        self.retryTimes = retryTimes
        self.delay = delay
    }
    
//    func shouldRetry(requestWith httpResponse: NCHTTPResponse) -> Bool {
//        httpResponse.classification == .serverError
//    }
}
