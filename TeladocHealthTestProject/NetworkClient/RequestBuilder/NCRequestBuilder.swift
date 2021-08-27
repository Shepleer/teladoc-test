//
//  NCRequestBuilder.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 18/08/2021.
//

import Foundation

protocol RequestBuilder {
    func makeRequest<R>(from requestConfiguration: R) throws -> URLRequest where R: RequestModel
}

class NCRequestBuilder: RequestBuilder {
    
    var host: String
    var defaultHeaders: [String: String]
    var defaultParams: [String: Encodable]
    var requestLifetime: TimeInterval
    
    init(
        host: String,
        defaultHeaders: [String: String] = [:],
        defaultParams: [String: String] = [:],
        requestLifetime: TimeInterval = 0
    ) {
        self.host = host
        self.defaultHeaders = defaultHeaders
        self.defaultParams = defaultParams
        self.requestLifetime = requestLifetime
    }
    
    func makeRequest<R>(from requestConfiguration: R) throws -> URLRequest where R: RequestModel {
        let url: URL
        if let customURL = requestConfiguration.customURL {
            url = customURL
        } else {
            url = try makeURL(for: requestConfiguration)
        }
        
        let headers = defaultHeaders.merging(requestConfiguration.headers, uniquingKeysWith: { $1 })
        
        var request = URLRequest(
            url: url,
            cachePolicy: requestConfiguration.cachePolicy,
            timeoutInterval: requestConfiguration.timeoutInterval
        )
        
        request.allHTTPHeaderFields = headers
        request.httpMethod = requestConfiguration.method.rawValue
        
        if let parameters = requestConfiguration.parameters, requestConfiguration.method == .post {
            request.httpBody = try makeHttpBody(from: parameters)
        }
        
        return request
    }
    
    private func makeURL(for configuration: RequestModel) throws -> URL {
        var urlComponents: URLComponents? = .init(string: host)
        urlComponents?.path = configuration.path

        if let parameters = configuration.parameters, configuration.method != .post {
            urlComponents?.queryItems = makeURLQueries(from: parameters)
        }

        guard let url =  urlComponents?.url else {
            throw NCError.requestBuildError(.wrongURL)
        }
        return url
    }
    
    private func makeHttpBody(from model: [String: Any]) throws -> Data {
        do {
            return try JSONEncoder().encode(model.mapValues { AnyEncodable($0) })
        } catch {
            throw NCError.requestBuildError(.invalidRequestModel)
        }
    }
    
    /// TODO: I used here CustomStringConvertivle for convert any data types to string
    /// But there should be something like that: https://github.com/Alamofire/Alamofire/blob/master/Source/URLEncodedFormEncoder.swift
    private func makeURLQueries(from parameters: [String: Any]) -> [URLQueryItem] {
        return parameters.map { key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
