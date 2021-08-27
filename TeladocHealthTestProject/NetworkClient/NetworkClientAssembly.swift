//
//  NetworkClientAssembly.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 26/08/2021.
//

import Foundation

class NetworkClientAssembly {
    static func makeClient(with configuration: NCSessionConfiguration) -> NetworkClient {
        let sessionDelegate = NCSessionDelegate()
        let urlSession = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
        
        let builder = NCRequestBuilder(
            host: configuration.host,
            defaultHeaders: configuration.defaultHeaders
        )
        let executor = NCRequestExecutor(with: urlSession)
        let parser = NCHandler()
        let retryer = NCRetrier(retryTimes: 0, delay: 0)
        let client = NetworkClient(builder: builder, executor: executor, parcer: parser, retrier: retryer)
        
        sessionDelegate.delegate = client
        
        return client
    }
}
